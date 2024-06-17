from pinecone import Pinecone, PodSpec



from dotenv import load_dotenv
import os
import time
import cohere
import datetime


class DBController():

    def __init__(self, modelContextWindow=1024, embeddingSize=384):
        #Lets verify if the database is up and running
        load_dotenv()
        self.db = self.initDatabase()
        self.modelContextWindow = modelContextWindow
        self.embeddingSize = embeddingSize
        self.reranker = self.loadReranker()
        # self.dropDB("mdrag", True)
        self.createIndex("mdrag")
    

    def dropDB(self, index_name, all=False):
        if all:
            indexes = self.db.list_indexes().names()
            for index in indexes:
                self.db.delete_index(index)
            print("All indexes deleted")
        else:
            if index_name in self.db.list_indexes().names():
                self.db.delete_index(index_name)
                print("Index deleted")


    def createIndex(self, index_name):
        try:
            # Verify if index is already created
            existed = False
            if index_name not in self.db.list_indexes().names():
                # 384 is the default dimension for the embedding model
                # We will use dotproduct since we want to tell how similar two vectors are
                self.db.create_index(name=index_name,
                                    dimension=self.embeddingSize,
                                    metric = "cosine",
                                    spec=PodSpec(
                                        environment="gcp-starter"
                                    )
                    )
                existed=True
            while not self.db.describe_index(index_name).status["ready"]:
                print("Waiting for the index to be created")
                time.sleep(1)

            self.index = self.db.Index(index_name)
        
            print("Index created")
            return existed

        except Exception as e:
            print("Error creating index", e)

    def insert(self, data):
        try:
            
            self.index.upsert([data])

        except Exception as e:
            print("Error inserting data", e)


    def loadReranker(self):
        try:
            coherekey = os.getenv("cohereapikey")
            model = cohere.Client(api_key=coherekey)
            return model

        except Exception as e:
            print("Error loading the reranker model", e)
            return None
        

    def compareDocs(self, rerankedDocs, docs, fileName=None):
        try:
            if not fileName:
                for key in docs:
                    if key in rerankedDocs:
                        print("Score:", key)
                        print("Original")
                        for doc in docs[key]:
                            print(doc[0])
                        print("Reranked")
                        for doc in rerankedDocs[key]:
                            print(doc[0])
                        print("\n")
                    else:
                        print("Score:", key)
                        print("Original")
                        for doc in docs[key]:
                            print(doc[0])
                        print("\n")

            else:
                # Lets open the file to save
                with open(fileName, "w") as file:
                    for key in docs:
                        if key in rerankedDocs:
                            file.write("Score: " + str(key) + "\n")
                            file.write("Original" + "\n")
                            for doc in docs[key]:
                                file.write(doc[0] + "\n")
                            file.write("Reranked" + "\n")
                            for doc in rerankedDocs[key]:
                                file.write(doc[0] + "\n")
                            file.write("\n")
                        else:
                            file.write("Score: " + str(key) + "\n")
                            file.write("Original" + "\n")
                            for doc in docs[key]:
                                file.write(doc[0] + "\n")
                            file.write("\n")

        except Exception as e:
            print("Error comparing documents", e)


    def runQuery(self, query, filters={}, queryText=None):
        try:

            # Reranked docs
            print("Filters", filters)
            rerankedDocs = {}

            queryresult = self.index.query(
                vector=query,
                top_k=25,
                include_values=True,
                include_metadata=True,
                filter=filters
            )

            results = queryresult["matches"]


            # A query devia estar em plain text e aqui é que damos embed
            # Quero guardar os ids para depois ir buscar as sources
            reranked_docs = self.reranker.rerank(query=queryText, 
                                                 documents = [result["metadata"]["texto"] for result in results], 
                                                 top_n=5,
                                                 model="rerank-multilingual-v2.0")
            
            
            for doc in reranked_docs:
                if "results" in doc[0]:
                    for i in doc[1]:                
                        index = i.index
                        score = results[index]["score"]
                        answer = results[index]["metadata"]["texto"]
                        source = results[index]["metadata"]["source"]
                        if score not in rerankedDocs:
                            rerankedDocs[score] = [(answer, source)]
                        else:
                            rerankedDocs[score].append((answer, source))


                    # for i in doc["results"]:
                    #     print(i)

                    
            # Original version
            docs = {}
            for result in range(min(len(results),5)):
                result = results[result]

                originalId = result["id"]
                
                text = self.index.query(
                    id=originalId, 
                    top_k=1, 
                    include_metadata=True
                )
                # print("Text", text)
                # print("Original ID", originalId)
                # TODO: Retrieve the party that has the information in order to enhance the answer
                
                try:
            
                    metadata = text["matches"][0]["metadata"]
                    partido = metadata["partido"]
                    originalDocumentId = metadata["document_id"]  
                    # print("Original Document ID", originalDocumentId)
                    previousId = str(int(originalId)-1)
                    nextId = str(int(originalId)+1)
                    # print("Previous ID", previousId)
                    # print(type(previousId))

                    previous_text = self.index.query(
                        id = previousId,
                        top_k=1, 
                        include_metadata=True,
                        filter={
                            "document_id" : originalDocumentId
                            }
                        )
                    
                    next_text = self.index.query(
                        id = nextId,
                        top_k=1, 
                        include_metadata=True,
                        filter={
                            "document_id" : originalDocumentId
                            }
                        )
            
                    # print("Extra context added")
                    alteredText = previous_text + metadata["texto"] + next_text
                    
                except:
                    alteredText = text["matches"][0]["metadata"]["texto"]
                

                # # Print result
                score = result["score"]
                answer = alteredText
                source = text["matches"][0]["metadata"]["source"]
                # print("Score:", score)
                # print("Query response:", answer)
                
                if score not in docs:
                    docs[score] = [(answer, source)]

                else:
                    docs[score].append((answer, source))
            
            # date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            # self.compareDocs(rerankedDocs, docs, f"./output_{date}.txt")  
            
            return rerankedDocs

        except Exception as e:
            print("Error querying the database", e)
            return None


    def initDatabase(self):
        try:
            api_key = os.getenv("PINECONE_API_KEY")
            print("Pinecone API Key", api_key)
            pinecone = Pinecone(api_key=api_key)
            print("Database initialized")
            return pinecone

        except Exception as e:
            print("Error initializing database", e)
            return None
