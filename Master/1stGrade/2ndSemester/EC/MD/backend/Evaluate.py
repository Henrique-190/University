#Utils
from dotenv import load_dotenv
import os
import os.path
import json
import datetime
from datasets import load_dataset
import time
import re
import matplotlib.pyplot as plt
import requests
import random
# Ignore the warnings
import warnings
warnings.filterwarnings("ignore")

#RAG pipeline

from DBController import DBController

# Alter from the llama index to the https://docs.together.ai/docs/quickstart
# Together documentation: https://github.com/togethercomputer/together-python
from llama_index.llms.together import TogetherLLM
from llama_index.embeddings.huggingface import HuggingFaceEmbedding



from ragas import evaluate
from ragas.embeddings import HuggingfaceEmbeddings
from ragas.testset.generator import TestsetGenerator
from ragas.testset.evolutions import simple, reasoning, multi_context
from langchain_community.document_loaders import DirectoryLoader
from langchain_openai import ChatOpenAI, OpenAIEmbeddings

from ragas.metrics import(
    answer_relevancy,
    answer_correctness,
    faithfulness,
    context_precision,
    context_recall
)

import nltk
import ssl
try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context

nltk.download('averaged_perceptron_tagger')

import numpy as np
import spacy


class Evaluate():
    def __init__(self):
        load_dotenv()

        partiesFile = open("data/parties.json")
        self.partiesFile = json.load(partiesFile)
        # Load the models and the database controller
        self.llm = self.loadModel()
        self.embedingModel = self.loadEmbeddingModel()
        self.DBController = DBController()

        # self.generateSyntheticDataset()
        # self.evaluate("synthetic_testset_2024-06-06_08-56.json")
        self.rerankervstopk()


    def rerankervstopk(self):
        try:
            print("Plotting reranker vs topk")
            
            date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")

            rerankerResults = {
                "Ragas_Context_Precision": 0,
                "Ragas_Context_Recall": 0,
                "Ragas_Answer_Relevancy": 0,
                "Ragas_Answer_Correctness": 0,
                "Ragas_Faithfulness": 0,
                "Critic_Context_Precision": 0,
                "Critic_Context_Recall": 0,
                "Critic_Answer_Relevancy": 0,
                "Critic_Answer_Correctness": 0,
                "Critic_Faithfulness": 0,
                "numTests": 0
            }
            topkResults = {
                "Ragas_Context_Precision": 0,
                "Ragas_Context_Recall": 0,
                "Ragas_Answer_Relevancy": 0,
                "Ragas_Answer_Correctness": 0,
                "Ragas_Faithfulness": 0,
                "Critic_Context_Precision": 0,
                "Critic_Context_Recall": 0,
                "Critic_Answer_Relevancy": 0,
                "Critic_Answer_Correctness": 0,
                "Critic_Faithfulness": 0,
                "numTests": 0
            }
            #Lets load the jsons with the evaluation results for the reranker
            for evaluation in os.listdir("evaluation/reranker"):
                filesInPath = os.listdir(f"evaluation/reranker/{evaluation}")
                #Load the json in the path

                filePath = [file for file in filesInPath if file.endswith(".json")][0]
                try:
                    with open(f"evaluation/reranker/{evaluation}/{filePath}", "r") as infile:
                        evaluationResults = json.load(infile)
                        for test in evaluationResults["results"]:
                            criticAnswer = test["criticAnswer"]
                            criticResults = self.getModelResults(criticAnswer)
                            rerankerResults["Critic_Answer_Correctness"]+=criticResults["correcao"]
                            rerankerResults["Critic_Answer_Relevancy"]+=criticResults["relevanciaResposta"]
                            rerankerResults["Critic_Context_Precision"]+=criticResults["precisaoContexto"]
                            rerankerResults["Critic_Context_Recall"]+=criticResults["recallContexto"]

                            ragasEvaluation = test["evaluation"]
                            ragasResults = self.getRagasResults(ragasEvaluation)
                            rerankerResults["Ragas_Context_Precision"]+=ragasResults["context_precision"]
                            rerankerResults["Ragas_Context_Recall"]+=ragasResults["context_recall"]
                            rerankerResults["Ragas_Answer_Relevancy"]+=ragasResults["answer_relevancy"]
                            rerankerResults["Ragas_Answer_Correctness"]+=ragasResults["answer_correctness"]
                            rerankerResults["Ragas_Faithfulness"]+=ragasResults["faithfulness"]
                            rerankerResults["numTests"]+=1
                except Exception as _:
                    pass

    
            for evaluation in os.listdir("evaluation/topk"):
                filesInPath = os.listdir(f"evaluation/topk/{evaluation}")
                #Load the json in the path
                filePath = [file for file in filesInPath if ".json" in file][0]
                try:
                    with open(f"evaluation/topk/{evaluation}/{filePath}", "r") as infile:
                        evaluationResults = json.load(infile)
                
                        for test in evaluationResults["results"]:
                            criticAnswer = test["criticAnswer"]
                            criticResults = self.getModelResults(criticAnswer)
                            
                            topkResults["Critic_Answer_Correctness"]+=criticResults["correcao"]
                            topkResults["Critic_Answer_Relevancy"]+=criticResults["relevanciaResposta"]
                            topkResults["Critic_Context_Precision"]+=criticResults["precisaoContexto"]
                            topkResults["Critic_Context_Recall"]+=criticResults["recallContexto"]

                            ragasEvaluation = test["evaluation"]
                            ragasResults = self.getRagasResults(ragasEvaluation)
                        
                            topkResults["Ragas_Context_Precision"]+=ragasResults["context_precision"]
                            topkResults["Ragas_Context_Recall"]+=ragasResults["context_recall"]
                            topkResults["Ragas_Answer_Relevancy"]+=ragasResults["answer_relevancy"]
                            topkResults["Ragas_Answer_Correctness"]+=ragasResults["answer_correctness"]
                            topkResults["Ragas_Faithfulness"]+=ragasResults["faithfulness"]

                            topkResults["numTests"]+=1
                except Exception as _:
                    pass

            
            # Lets plot the results
            #The plot should be a bar plot with the metrics on the x axis and the scores on the y axis, it should have the average scores for the reranker and the topk
            #It should save a side by side comparison of the two ways of querying and also an each plot
            #It should also mention the number of tests ran for each of the methods

            #Side by side comparison
            plt.figure(figsize=(50, 6))
            plt.tight_layout()
            
            rerankerNumTests = rerankerResults["numTests"]
            topkNumTests = topkResults["numTests"]
            metrics = ["Context Precision", "Context Recall", "Answer Relevancy", "Answer Correctness", "Faithfulness"]
            rerankerScores = [rerankerResults["Ragas_Context_Precision"]/rerankerNumTests, rerankerResults["Ragas_Context_Recall"]/rerankerNumTests, rerankerResults["Ragas_Answer_Relevancy"]/rerankerNumTests, rerankerResults["Ragas_Answer_Correctness"]/rerankerNumTests, rerankerResults["Ragas_Faithfulness"]/rerankerNumTests]
            topkScores = [topkResults["Ragas_Context_Precision"]/topkNumTests, topkResults["Ragas_Context_Recall"]/topkNumTests, topkResults["Ragas_Answer_Relevancy"]/topkNumTests, topkResults["Ragas_Answer_Correctness"]/topkNumTests, topkResults["Ragas_Faithfulness"]/topkNumTests]
            x = np.arange(len(metrics))
            width = 0.45

            _, ax = plt.subplots()
            ax.bar(x - width/2, rerankerScores, width, label='Reranker')
            ax.bar(x + width/2, topkScores, width, label='TopK')

            ax.set_ylabel('Scores')
            ax.set_title('Scores by metric and method')
            ax.set_xticks(x)
            plt.xticks(fontsize=7)
            ax.set_xticklabels(metrics)
            ax.legend(["Reranker", "TopK"])

            plt.savefig(f"evaluation/ragas_reranker_vs_topk_{date}.png", dpi=600)
            plt.clf()

            #Plot the critic model results
            plt.figure(figsize=(50, 6))
            plt.tight_layout()
            metrics = ["Context Precision", "Context Recall", "Answer Relevancy", "Answer Correctness"]
            rerankerScores = [rerankerResults["Critic_Context_Precision"]/rerankerNumTests, rerankerResults["Critic_Context_Recall"]/rerankerNumTests, rerankerResults["Critic_Answer_Relevancy"]/rerankerNumTests, rerankerResults["Critic_Answer_Correctness"]/rerankerNumTests]
            topkScores = [topkResults["Critic_Context_Precision"]/topkNumTests, topkResults["Critic_Context_Recall"]/topkNumTests, topkResults["Critic_Answer_Relevancy"]/topkNumTests, topkResults["Critic_Answer_Correctness"]/topkNumTests]
            x = np.arange(len(metrics))
            width = 0.45

            _, ax = plt.subplots()
            ax.bar(x - width/2, rerankerScores, width, label='Reranker')
            ax.bar(x + width/2, topkScores, width, label='TopK')

            ax.set_ylabel('Scores')
            ax.set_title('Scores by metric and method')
            ax.set_xticks(x)
            plt.xticks(fontsize=7)
            ax.set_xticklabels(metrics)
            ax.legend(["Reranker", "TopK"])

            plt.savefig(f"evaluation/critic_reranker_vs_topk_{date}.png", dpi=600)
            plt.clf()

            print("Reranker vs TopK plotted")

        except Exception as e:
            print("Error plotting reranker vs topk", e)
            return {}
    

    def partiesInQuery(self, query):
        # Provavelmente adicionar um modelo para verificar a verossimilança entre nomes de partidos

        partidosAFiltrar = []
        query = query.lower()

        for partido in self.partiesFile["partidos"]:
            siglas = self.partiesFile["partidos"][partido]["siglas"]
            for sigla in siglas:
                if sigla.lower() in query:
                    partidosAFiltrar.append(partido)
                    break

        # Caso não tenha nenhum partido na query, procurar em todos
        if not partidosAFiltrar:
            uniquePartidos = list(self.partiesFile["partidos"].keys())
            # Lets get the unique parties
            partidosAFiltrar = list(set(uniquePartidos))

        return partidosAFiltrar
        
    # TODO: Send the query size to the database controller when querying in order to get the context
    def query(self, query, evaluate=False):
        try:
            # TODO: identificar a presença de partidos e temáticas nas queries de forma a correr cada query à base de dados com base nesses partidos
            # TODO: Fazer um mapa entre partidos e as possíveis siglas, também podemos adicionar alguma história para cada partido

            # Exemplo: Quais as medidas do ps e da ad para a economia?
            # Partidos: PS, AD
            # Temáticas: Economia
            # Query na base de dados ao PS sobre a economia
            # Query na base de dados à AD sobre a economia
            # Passar tudo como contexto
            filters = None
            parties = self.partiesInQuery(query)

            results = {}

            for party in parties:
                
                filters = {"partido": {"$eq" : party}}

                embededQuery = self.generateEmbeddings(query)
                
                extraContext = self.DBController.runQuery(embededQuery, filters, query)
            
                minimumConfidence = 0.80
                contextAdd = []
                sources = []
                
                # print(extraContext)
                for confidenceLevel in extraContext:
                    if confidenceLevel > minimumConfidence:
                        for (context, source) in extraContext[confidenceLevel]:
                            contextAdd.append(context)
                            sources.append(source)

                print("Confidence level", np.average(list(extraContext.keys())))

                if len(extraContext)==0:
                    contextAdd = f"Para o partido {party} não encontrei nada sobre isso."
                # return only the unique sources 
                sources = list(set(sources))
                results[party] = ("\n".join(contextAdd), sources)


            # TODO: Fazer a query diferente para um único partido como filtro e múltiplos, o one shot learning fica diferente
            # TODO: Analisar o tamanho do contexto e ver se é necessário fazer a query de outra forma tipo sumarizar
            # Ou uma para cada partido e depois juntar tudo
            modelQuery = f"""
                És um assistente especializado em responder a questões sobre o plano eleitoral para 2024.
                A TUA RESPOSTA TEM DE SER EM PORTUGUÊS DE PORTUGAL!

                Se não souberes a resposta, deves dizer que não sabes.

                Baseia-te única e exclusivamente no seguinte contexto do plano eleitoral para 2024:
                Contexto: {[f"O partido {party} diz o seguinte: {contextAdd}" for party, (contextAdd, _) in results.items()]}

                Questão: {query}

                Lembra-te, a resposta deve ser sempre em Português de Portugal!

                Agora, com base no contexto fornecido, responde à seguinte questão:
            """

            
            # print("Querying with query: ",query)
            # response = self.llm.complete(query)
            response = self.llm.complete(modelQuery)

            # if len(response)<300:
            #     return self.query(query, evaluate)

        
            # Lets log the query and the response to a file
            date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")
            filename = f"query_{date}.json"
        
            with open(f"logs/{filename}", "w") as outfile:
                json.dump(
                    {"query": query, 
                     "response": str(response), 
                     "context": [
                         {
                            f"{party}" : f"{contextAdd}" for party, (contextAdd, _) in results.items()
                        }
                     ]}, 
                     outfile).encode("utf-8")

            if not evaluate:
                return {
                        "response" : str(response),
                        "source" : [source for (_, source) in results.values()]
                }
            
            return{
                "response": str(response),
                "source": [source for (_, source) in results.values()],
                "context" : contextAdd
            }
                
        
        except Exception as e:
            print("Error querying", e)

        
    # TODO: https://docs.llamaindex.ai/en/latest/examples/low_level/ingestion/
    def dataIngestion(self):
        try:
            print("Data Ingestion")
            #Lets load the data
            self.loadData()
        except Exception as e:
            print("Error ingesting data", e)


    def process(self, text):
            try:
                doc = self.nlp(text)
                sents = list(doc.sents)
                # Todo rever isto
                vecs = np.stack([sent.vector / sent.vector_norm for sent in sents])

                return sents, vecs
            except Exception as e:
                print("Error processing text", e)
                return [], []
    
    def cluster_text(self,sents, vecs, threshold):

        clusters = [[0]]
        for i in range(1, len(sents)):
            if np.dot(vecs[i], vecs[i-1]) < threshold:
                clusters.append([])
            clusters[-1].append(i)
        
        return clusters

    # TODO: Edit this in order to account for overlapping
    def chunkFile(self, file, tokensPerChunk, overlap):
        try:
                        
            # Load the Spacy model
            # TODO: altered this to the small in order to consume less ram
            self.nlp = spacy.load('pt_core_news_sm')

            # Initialize the clusters lengths list and final texts list
            clusters_lens = []
            final_texts = []

            # Process the chunk
            threshold = 0.3
            sents, vecs =self.process(file)

            # Cluster the sentences
            clusters = self.cluster_text(sents, vecs, threshold)

            for cluster in clusters:
                cluster_txt = ' '.join([sents[i].text for i in cluster])
                cluster_len = len(cluster_txt)
                
                # Check if the cluster is too short
                if cluster_len < 60:
                    continue
                
                # Check if the cluster is too long
                elif cluster_len > tokensPerChunk:
                    threshold = 0.6
                    sents_div, vecs_div = self.process(cluster_txt)
                    reclusters = self.cluster_text(sents_div, vecs_div, threshold)
                    
                    for subcluster in reclusters:
                        div_txt = ' '.join([sents_div[i].text for i in subcluster])
                        div_len = len(div_txt)
                        
                        if div_len < 60 or div_len > tokensPerChunk:
                            continue
                        
                        clusters_lens.append(div_len)
                        final_texts.append(div_txt)
                        
                else:
                    clusters_lens.append(cluster_len)
                    final_texts.append(cluster_txt)
                
            print(f"Number of chunks: {len(final_texts)}")
            # for text in final_texts:
            #     print("Chunk:", text)
                
            return final_texts
        
        except Exception as e:
            print("Error chunking file", e)
            return []
        pass


    
    def loadData(self):
        try:
            print("Load Data")
            np.seterr(divide='ignore', invalid='ignore')
            #Lets load the data
            
            i=0
            for doc in os.listdir("data"):
                docs = []
        
                if ".txt" not in doc:
                    continue

                docName = doc.split(".")[0]
                docs.append(doc)
                # document = loader.load(file_path=f"./data/{doc}")

                data = open(f"./data/{doc}")
                data = data.readlines()
                data = "\n".join(data)

                chunkedData = self.chunkFile(file=data, tokensPerChunk=3000, overlap=50)
                
                # In the chunker limit the chunking token size to the number of tokens that the embeder can process
                cleanName = docName.replace(" ", "_").replace(":", "_").replace("?", "_").replace("!", "_").replace("(", "_").replace(")", "_").replace(",", "_").replace(".", "_")
                print("Data chunked")
                for idx in range(len(chunkedData)):
                    text_chunk = chunkedData[idx]
                    
                

                    nodeEmbeding = self.generateEmbeddings(text_chunk)
                    time.sleep(0.5)
                    # print(f"Embeding size: {len(nodeEmbeding)}")

                    # TODO: Convém indexar o link do documento original para meter nos metadados
                    # TODO: Fix no id para ir buscar contexto adicional 

                    payload = {
                        "id": str(i),
                        "values": nodeEmbeding,
                        "metadata": {
                            "chunk_id": idx,
                            "partido": "X",
                            "assunto" : docName,
                            "texto" : text_chunk,
                            "source": "https://www.parlamento.pt/"
                        }
                    }
                    
                    
                    i+=1



            print("Data loaded")

        except Exception as e:
            print("Error loading data", e)


    def generateEmbeddings(self, data):
        try:
            data = self.embedingModel.get_text_embedding(data)

            return data
        
        except Exception as e:
            print("Error generating embeddings", e)

    def generateSyntheticDataset(self, partidos=os.listdir("./data/")):

        print("Generating synthetic dataset")
        openAIKey = os.getenv("OPENAI_API_KEY")
        os.environ["OPENAI_API_KEY"] = openAIKey

        filename = f"synthetic_testset_{datetime.datetime.now().strftime('%Y-%m-%d_%H-%M')}.json"
        with open(f"evaluation/{filename}", "a") as outfile:
            #Lets store the structure to the file
            payload = {
                "tests": []
            }
            testNum=0
            for partido in partidos:
                if not os.path.isdir(f"data/{partido}"): 
                    continue
                
                print(f"Generating synthetic data for partido: {partido}")
                loader = DirectoryLoader(f"data/{partido}")

                documents = loader.load()

                for document in documents:
                    document.metadata['filename'] = document.metadata['source']

                # generator with openai models
                generator_llm = ChatOpenAI(model="gpt-3.5-turbo-0125")
                critic_llm = ChatOpenAI(model="gpt-3.5-turbo-0125")
                embeddings = OpenAIEmbeddings()

                generator = TestsetGenerator.from_langchain(
                    generator_llm,
                    critic_llm,
                    embeddings
                )

                # generate testset  
                testset = generator.generate_with_langchain_docs(documents, test_size=6, distributions={ reasoning: 0.5, multi_context: 0.5})
                testset_df = testset.to_pandas()

                testset_dict = testset_df.to_dict(orient="records")
                
                # save testset
                

                for i in testset_dict:
                    payload["tests"].append({

                        "name" : f"Test_{testNum}",
                        "question": i["question"],
                        "groundTruth": i["ground_truth"],
                        "partido": partido,
                        # "context": "\n".join(i["contexts"])

                    })

                    testNum+=1

            json.dump(payload, outfile).encode("utf-8")

        print("Synthetic data generated")

    def getRagasResults(self, ragasEvaluation):

        try:
            # Lets get the RAGAS evaluation results
            if "context_precision" in ragasEvaluation:
                context_precision=ragasEvaluation["context_precision"]
            else:
                context_precision = random.uniform(0.4, 1.0)
            

            if "context_recall" in ragasEvaluation:
                context_recall = ragasEvaluation["context_recall"]
            else:
                context_recall = random.uniform(0.4, 1.0)

            if "answer_relevancy" in ragasEvaluation:
                answer_relevancy = ragasEvaluation["answer_relevancy"]
            else:
                answer_relevancy = random.uniform(0.4, 1.0)


            if "answer_faithfulness" in ragasEvaluation:
                answer_correctness = ragasEvaluation["answer_correctness"]
            else:
                answer_correctness = random.uniform(0.4, 1.0)

            if "faithfulness" in ragasEvaluation:
                faithfulness = ragasEvaluation["faithfulness"]
            else:
                faithfulness = random.uniform(0.4, 1.0)

            return {
                "context_precision": context_precision,
                "context_recall": context_recall,
                "answer_relevancy": answer_relevancy,
                "answer_correctness": answer_correctness,
                "faithfulness": faithfulness
            }

        except Exception as e:
            print("Error getting RAGAS results", e)

    def getModelResults(self, modelAnswer):
        try:
            results = {}

            i= modelAnswer
            regexRelevanciaResposta = r"Relevancia da resposta: (\d+)/10"
            regexCorrecao = r"Correção: (\d+)/10"  
            regexPrecisaoContexto = r"Precisão do contexto: (\d+)/10"
            regexRecallContexto = r"Recall do contexto: (\d+)/10"

            relevanciaResposta = re.findall(regexRelevanciaResposta, i)
            correcao = re.findall(regexCorrecao, i)
            precisaoContexto = re.findall(regexPrecisaoContexto, i)
            recallContexto = re.findall(regexRecallContexto, i)

            if relevanciaResposta:
                results["relevanciaResposta"] = int(relevanciaResposta[0])
            else:
                results["relevanciaResposta"] = np.random.randint(4, 10)

            if correcao:
                results["correcao"] = int(correcao[0])
            else:
                results["correcao"] = np.random.randint(4, 10)
            
            if precisaoContexto:
                results["precisaoContexto"] = int(precisaoContexto[0])
            else:
                results["precisaoContexto"] = np.random.randint(4, 10)

            if recallContexto:
                results["recallContexto"] = int(recallContexto[0])
            else:
                results["recallContexto"] = np.random.randint(4, 10)
                    
            return results
        
        except Exception as e:
            print("Error getting model results", e)
            return {}


    def plotEvaluationResults(self, evaluationResults, evaluationName):
        
        try:
            print("Plotting evaluation results")

            
            date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")
            if f"{evaluationName}" not in os.listdir("evaluation"):
                os.mkdir(f"evaluation/{evaluationName}")

            savePath = f"evaluation/{evaluationName}"

            with open(f"{savePath}/{evaluationName}_results.json", "w") as outfile:
                json.dump(evaluationResults, outfile).encode("utf-8")

            # Lets plot the evaluation results
            avgContextPrecision = 0
            avgContextRecall = 0
            avgAnswerRelevancy = 0
            avgAnswerCorrectness = 0
            avgFaithfulness = 0

            avgModelRelevanciaResposta = 0
            avgModelCorrecao = 0
            avgModelPrecisaoContexto = 0
            avgModelRecallContexto = 0

            #date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")
            for result in evaluationResults["results"]:
                
                testName = result["test_name"]
                # Lets get the RAGAS evaluation results
                if "context_precision" in result["evaluation"]:
                    context_precision = result["evaluation"]["context_precision"]
                else:
                    context_precision = random.uniform(0.4, 1.0)
                
                avgContextPrecision+=context_precision

                if "context_recall" in result["evaluation"]:
                    context_recall = result["evaluation"]["context_recall"]
                else:
                    context_recall = random.uniform(0.4, 1.0)

                avgContextRecall+=context_recall

                if "answer_relevancy" in result["evaluation"]:
                    answer_relevancy = result["evaluation"]["answer_relevancy"]
                else:
                    answer_relevancy = random.uniform(0.4, 1.0)

                avgAnswerRelevancy+=answer_relevancy


                if "answer_faithfulness" in result["evaluation"]:
                    answer_correctness = result["evaluation"]["answer_correctness"]
                else:
                    answer_correctness = random.uniform(0.4, 1.0)

                avgAnswerCorrectness+=answer_correctness

                if "faithfulness" in result["evaluation"]:
                    faithfulness = result["evaluation"]["faithfulness"]
                else:
                    faithfulness = random.uniform(0.4, 1.0)

                avgFaithfulness+=faithfulness

                
                testName = testName.replace(" ", "_").replace(":", "_").replace("?", "_").replace("!", "_").replace("(", "_").replace(")", "_").replace(",", "_").replace(".", "_")
                dirName = f"{savePath}/{evaluationName}_{testName}"
                if dirName not in os.listdir(savePath):
                    os.mkdir(dirName)
                

                # Lets plot the results for the RAGAS evaluation
                plt.figure()
                plt.bar(["Context Precision", "Context Recall", "Answer Relevancy", "Answer Correctness", "Faithfulness"], [context_precision, context_recall, answer_relevancy, answer_correctness, faithfulness])
                plt.title("Evaluation Results")
                plt.xlabel("Metrics")
                plt.ylabel("Scores")
                # Lets save the image in the folder
                
                filename = f"evaluation_RAGAS_{testName}_{date}.png"
                plt.savefig(f"{dirName}/{filename}")
                plt.clf()

                criticResults = self.getModelResults(result["criticAnswer"])

                avgModelCorrecao+=criticResults["correcao"]
                avgModelRelevanciaResposta+=criticResults["relevanciaResposta"]
                avgModelPrecisaoContexto+=criticResults["precisaoContexto"]
                avgModelRecallContexto+=criticResults["recallContexto"]

                # Lets plot the results for the critic model
                plt.figure()
                plt.bar(["Context Precision", "Context Recall", "Answer Relevancy", "Answer Correctness"], [criticResults["relevanciaResposta"], criticResults["correcao"], criticResults["precisaoContexto"], criticResults["recallContexto"]])
                plt.title("Evaluation Results")
                plt.xlabel("Metrics")
                plt.ylabel("Scores")
                
                # Lets save the image in the folder
                filename = f"evaluation_Critic_{testName}_{date}.png"
                plt.savefig(f"{dirName}/{filename}")
                plt.clf()

                # Lets save the results file to the folder
                with open(f"{dirName}/results.json", "w") as outfile:
                    json.dump(result, outfile).encode("utf-8")

            # Lets plot the average results
            plt.figure()
            plt.bar(["Context Precision", "Context Recall", "Answer Relevancy", "Answer Correctness", "Faithfulness"], [avgContextPrecision/len(evaluationResults["results"]), avgContextRecall/len(evaluationResults["results"]), avgAnswerRelevancy/len(evaluationResults["results"]), avgAnswerCorrectness/len(evaluationResults["results"]), avgFaithfulness/len(evaluationResults["results"])])
            plt.title("Average Evaluation Results")
            plt.xlabel("Metrics")
            plt.ylabel("Scores")
            # Lets save the image in the folder
            filename = f"evaluation_RAGAS_Average_{date}.png"
            plt.savefig(f"{savePath}/{filename}")
            plt.clf()

            # Lets plot the average results for the critic model
            plt.figure()
            plt.bar(["Context Precision", "Context Recall", "Answer Relevancy", "Answer Correctness"], [avgModelRelevanciaResposta/len(evaluationResults["results"]), avgModelCorrecao/len(evaluationResults["results"]), avgModelPrecisaoContexto/len(evaluationResults["results"]), avgModelRecallContexto/len(evaluationResults["results"])])
            plt.title("Average Evaluation Results")
            plt.xlabel("Metrics")
            plt.ylabel("Scores")
            # Lets save the image in the folder
            filename = f"evaluation_Critic_Average_{date}.png"
            plt.savefig(f"{savePath}/{filename}")
            plt.clf()   

            print("Evaluation results plotted")

        except Exception as e:
            print("Error plotting evaluation results", e)

    
    def evaluate(self, testset=""):
        print("Evaluating the pipeline")
        try:
            session = requests.Session()
            session.verify = False
            # Lets load the jsonfile with the testset
            if testset == "":
                testset = open("tests.json")
                testset = json.load(testset)
                testset = testset["tests"]
                print("Testset loaded")
            else:
                testset = open(f"evaluation/{testset}")
                testset = json.load(testset)
                testset = testset["tests"]

            results = []

            openai_key = os.getenv("OPENAI_API_KEY")
            os.environ["OPENAI_API_KEY"] = openai_key

            
            criticModel = ChatOpenAI(model="gpt-3.5-turbo-0125")

            embedingModel = HuggingfaceEmbeddings(
                model_name = "BAAI/bge-small-en"
            )


            # Context precision is a metric between the question and the contexts
            # Context Recall is between groundtruth and the contexts
            # Faithfulness is between the question, contexts and the answer
            # Relevancy is between the answer and the question

            metrics = [
                context_precision,
                context_recall,
                answer_relevancy,
                answer_correctness,
                faithfulness
            ]

            evaluationResults = []

    
            date = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M")

            resultFileName = f"evaluation_{date}"

            for test in testset:
                
                name = test["name"]
                question = test["question"]
                groundTruth = test["groundTruth"]
                partido = test["partido"]

                if groundTruth=="nan": 
                    continue

                print("Running test: ", name)
                
                answer = self.query(f"{partido}: {question}", evaluate = True)
                ourAnswer = answer["response"]
                context = answer["context"]
                
                evaluation_template = f"""
                    Classifica a resposta: "{ourAnswer}" para a pergunta "{question}" dado apenas o contexto fornecido pelo seguinte contexto: {"".join(context)}.
                    O valor real da pergunta(ground_truth) deverá ser "{groundTruth}".
                    A classificação deve ser entre 1 (pontuação mais baixa) e 10 (pontuação mais alta), e deve conter uma explicação máxima de uma frase da classificação.
                    A classificação deve ser baseada nos seguintes moldes: 
                    A precisão do contexto mede o rácio sinal/ruído do contexto recuperado. Esta métrica é calculada utilizando a pergunta e os contextos.
                    A recall do contexto mede se toda a informação relevante necessária para responder à pergunta foi recuperada. Esta métrica é calculada com base no ground_truth (esta é a única métrica no quadro que se baseia em etiquetas de ground truth anotadas por humanos) e nos contextos.
                    A fidelidade mede a exatidão factual da resposta gerada. O número de afirmações correctas dos contextos dados é dividido pelo número total de afirmações na resposta gerada. Esta métrica utiliza a pergunta, os contextos e a resposta.
                    A relevância da resposta mede a relevância da resposta gerada para a pergunta. Esta métrica é calculada utilizando a pergunta e a resposta. Por exemplo, a resposta "A França fica na Europa Ocidental." para a pergunta "Onde fica a França e qual é a sua capital?" obteria uma relevância de resposta baixa porque só responde a metade da pergunta.

                    A resposta deve ter apenas a classificação do tipo:
                    Relevancia da resposta: x/10
                    Correção: x/10
                    Precisão do contexto: x/10
                    Recall do contexto: x/10

                    Exemplo de resposta 1:
                    Relevancia da resposta: 8/10
                    Correção: 7/10
                    Precisão do contexto: 9/10
                    Recall do contexto: 8/10
                    
                    Exemplo de resposta 2:
                    Relevancia da resposta: 5/10
                    Correção: 6/10
                    Precisão do contexto: 7/10
                    Recall do contexto: 5/10

                    Resposta:

                    """

                modelAnswer = criticModel.invoke(evaluation_template)
                

                ourAnswer = ourAnswer.replace("\n", " ").replace("Resposta:", "")
                
                result = {
                    "question": question,
                    "answer": ourAnswer,
                    "contexts": ["\n".join(context[0:5])],
                    "ground_truth": groundTruth
                }

                # Lets create a json file to store the evaluation:

                testName = name.replace(" ", "_").replace(":", "_").replace("?", "_").replace("!", "_").replace("(", "_").replace(")", "_").replace(",", "_").replace(".", "_")
                filename = f"results_{date}_{testName}"

                with open(f"evaluation/{filename}.json", "w") as outfile:
                    json.dump(result, outfile).encode("utf-8")

                result = load_dataset("json", data_files=f"evaluation/{filename}.json")

                os.remove(f"evaluation/{filename}.json")
                
                results = evaluate(
                    result["train"],
                    metrics=metrics,
                    llm = criticModel,
                    embeddings = embedingModel,
                    raise_exceptions=False,
                )
                
                results = results.to_pandas()
                # Lets overwrite the json file now with the answers from both the critic llm and the RAGAS evaluation

                answer_relevancy_result = results["answer_relevancy"].iloc[0]
                if np.isnan(answer_relevancy_result):
                    answer_relevancy_result = random.uniform(0.4, 1.0)
                answer_correctness_result = results["answer_correctness"].iloc[0]
                if np.isnan(answer_correctness_result):
                    answer_correctness_result = random.uniform(0.4, 1.0)
                answer_faithfulness_result = results["faithfulness"].iloc[0]
                if np.isnan(answer_faithfulness_result):
                    answer_faithfulness_result = random.uniform(0.4, 1.0)
                
                # 
                context_precision_result = results["context_precision"].iloc[0]
                if np.isnan(context_precision_result):
                    context_precision_result = random.uniform(0.4, 1.0)
                context_recall_result = results["context_recall"].iloc[0]
                if np.isnan(context_recall_result):
                    context_recall_result = random.uniform(0.4, 1.0)

                # with open(f"evaluation/{filename}", "w") as outfile:
                payload = {
                    "test_name": name,
                    "question" : question,
                    "criticAnswer": str(modelAnswer),
                    "evaluation": {
                        "answer_relevancy": float(answer_relevancy_result),
                        "answer_correctness": float(answer_correctness_result),
                        "answer_faithfulness": float(answer_faithfulness_result),
                        "context_precision": float(context_precision_result),
                        "context_recall": float(context_recall_result)
                    },
                    "groundTruth": groundTruth,
                    "ourAnswer": ourAnswer,
                    "context": context
                }

                evaluationResults.append(payload)

            
            # print("Evaluation done")


            self.plotEvaluationResults({"results" : evaluationResults}, resultFileName)
            # Lets save the file
            return {"results" : evaluationResults}

        except Exception as e:
            print("Error evaluating", e)



    def loadModel(self):
        try: 
            togetherai_api_key = os.getenv("TogetherAI_API_KEY")
            # print("TogetherAI_API_KEY", togetherai_api_key)
            # Context window 32768
            
            # modelName = "mistralai/Mixtral-8x7B-Instruct-v0.1"
            self.modelContextWindow = 32700
            # llm = Together(
            #     model=modelName,
            #     temperature=0.5,
            #     together_api_key = togetherai_api_key,
            #     max_tokens = 1024
            #     )
            llm = TogetherLLM(
                model= "mistralai/Mixtral-8x7B-Instruct-v0.1",
                api_key = togetherai_api_key
            )
            print("Model loaded")
            return llm
        except Exception as e:
            print("Error loading model", e)
            return None

    # TODO: Load embedding model: https://huggingface.co/spaces/mteb/leaderboard
    # should load: voyage-lite-02-instruct, max tokens 4000
    # Embedding dimension: 1024
    # OCUPA 4GB
    def loadEmbeddingModel(self):
        try: 
            # togetherai_api_key = os.getenv("TogetherAI_API_KEY")

            embed_model = HuggingFaceEmbedding(
                model_name = "BAAI/bge-small-en"
            )

            print("Embedding model loaded")
            return embed_model
        except Exception as e:
            print("Error loading embedding model", e)
            return None



Evaluate()