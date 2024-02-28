import graphviz

# Create a new Graph object
graph = graphviz.Graph()

# Add nodes to the graph
graph.node('A')
graph.node('B')
graph.node('C')
graph.node('D')

# Add edges between the nodes
graph.edge('A', 'B')
graph.edge('B', 'C')
graph.edge('C', 'D')
graph.edge('D', 'A')

# Set graph attributes
graph.attr(rankdir='UD')  # Layout direction: Left to right

# Render and save the graph as a file
graph.render('example_graph', format='png', cleanup=True)

