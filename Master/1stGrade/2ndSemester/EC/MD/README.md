# Mineração de Dados
Um chatbot que responde a perguntas sobre os partidos políticos portugueses tendo em conta o seu programa eleitoral das eleições legislativas de 2024. Extraímos e processamos informações dos manifestos dos partidos, principalmente disponíveis em formato PDF. Utilizando Python, convertemos esses PDFs em arquivos .txt e empregamos técnicas de processamento de linguagem natural (NLP) para categorizar as medidas políticas por tema. A preparação dos dados incluiu a divisão de documentos em secções coerentes usando o *spaCy*, seguida pela geração de embeddings com o modelo BGE através da API da HuggingFace. Esses embeddings foram armazenados no Pinecone, uma base de dados vetorial otimizada para buscas por similaridade. O mecanismo de recuperação utiliza a seleção de documentos top-k com sobreposição contextual e um reranker para melhorar a precisão. Para gerar respostas às consultas dos utilizadores, experimentamos vários modelos, selecionando o Mixtral-8x7B pela sua relação custo-desempenho. Avaliamos a eficácia do sistema utilizando a framework RAGAS, que mede precisão do contexto, recall, fidelidade e relevância. O frontend, desenvolvido com React, oferece uma interface intuitiva para consultas dos utilizadores e interação com o modelo de linguagem.

## Estrutura do Repositório
- **article**: Contém o artigo final do projeto;
- **backend**: Contém o código do backend do chatbot. Para correr o backend, basta correr o comando `python app.py` dentro desta pasta. Alé, disso, esta pasta contém os dados de cada chat, users, testes realizados à pipeline e os dados dos partidos políticos;
- **frontend**: Contém o código do frontend do chatbot. Para correr o frontend, é necessário ter o Node.js instalado. Para instalar as dependências, correr o comando `npm install` e para correr o frontend, correr o comando `npm start` dentro desta pasta;
- **presentation**: Contém a apresentação final do projeto.

# Data Mining
A chatbot that answers questions about the Portuguese political parties considering their electoral program for the 2024 legislative elections. We extracted and processed information from the parties' manifestos, mainly available in PDF format. Using Python, we converted these PDFs into .txt files and employed natural language processing (NLP) techniques to categorize political measures by theme. Data preparation included dividing documents into coherent sections using *spaCy*, followed by generating embeddings with the BGE model through the HuggingFace API. These embeddings were stored in Pinecone, a vector database optimized for similarity searches. The retrieval mechanism uses top-k document selection with contextual overlap and a reranker to improve accuracy. To generate responses to user queries, we experimented with several models, selecting Mixtral-8x7B for its cost-performance ratio. We evaluated the system's effectiveness using the RAGAS framework, which measures context precision, recall, fidelity, and relevance. The frontend, developed with React, provides an intuitive interface for user queries and interaction with the language model.

## Repository Structure
- **article**: Contains the final article of the project;
- **backend**: Contains the backend code of the chatbot. To run the backend, simply run the command `python app.py` inside this folder. Additionally, this folder contains the data of each chat, users, tests performed on the pipeline, and the data of the political parties;
- **frontend**: Contains the frontend code of the chatbot. To run the frontend, you need to have Node.js installed. To install the dependencies, run the command `npm install` and to run the frontend, run the command `npm start` inside this folder;
- **presentation**: Contains the final presentation of the project.

# Autores / Authors
| ID | Name |
|----|------|
| pg53645 | Ana Rita Poças |
| pg50414 | Henrique Alvelos |
| pg52697 | Nelson Almeida |



