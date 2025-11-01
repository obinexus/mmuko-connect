def compute_pagerank(graph, damping_factor=0.85, max_iterations=100):
    """
    Compute the PageRank of each node in the graph.
    
    Parameters
    ----------
    graph : dict
        A dictionary representing the structure of the graph. The keys are
        the nodes in the graph, and the values are a list of the nodes that
        are connected to that node.
    damping_factor : float
        The damping factor for the PageRank algorithm.
    max_iterations : int
        The maximum number of iterations to perform before stopping.
    
    Returns
    -------
    dict
        A dictionary mapping each node in the graph to its PageRank score.
    """
    
    # Check for invalid damping factor
    if damping_factor <= 0 or damping_factor >= 1:
        raise ValueError("Invalid damping factor")
    
    # Initialize the PageRank of each node to 1
    pagerank = {node: 1 for node in graph.keys()}
    
    # Perform the PageRank algorithm for the given number of iterations
    for _ in range(max_iterations):
        for node in graph.keys():
            
            # Compute the sum of the PageRank scores of the nodes that are
            # connected to this node
            pagerank_sum = 0
            for neighbor in graph[node]:
                pagerank_sum += pagerank[neighbor]
            
            # Update the PageRank of this node
            pagerank[node] = (1 - damping_factor) + \
                (damping_factor * pagerank_sum)
    
    return pagerank

driver code.


# Create a graph
graph = {
    "A": ["B", "C"],
    "B": ["A", "C", "D"],
    "C": ["A", "B", "D", "E"],
    "D": ["B", "C", "E", "F"],
    "E": ["C", "D"],
    "F": ["D"]
}

# Compute the PageRank scores
pagerank = compute_pagerank(graph)

# Print the PageRank scores
for node, score in pagerank.items():
    print(node, ":", score)
