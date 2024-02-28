import java.util.HashMap;
import java.util.concurrent.locks.ReentrantLock;

public class Cache {
    // String -> domínio;type / Node -> nodos desse domínio
    private final HashMap<String, Node> cache;
    private final int capacity;
    private final Node head;
    private final Node tail;
    private final ReentrantLock lock;

    public Cache(int capacity) {
        this.lock = new ReentrantLock();
        this.capacity = capacity;
        this.cache = new HashMap<>();
        this.head = new Node();
        this.tail = new Node();
        head.next = tail;
        tail.prev = head;
    }

    public Message get(String key, boolean secondary) {
        Node node = cache.get(key);
        if (node == null) {
            return null;
        }

        if (System.currentTimeMillis() > node.expirationTime ||
                (System.currentTimeMillis() > node.SOAEXPIRE && secondary)) {
            // Node has expired, remove it from the cache
            removeNode(node);
            cache.remove(key);
            return null;
        }

        moveToFront(node);
        return node.value;
    }

    public void put(String key, Message value, int priority, int soaexpire, long ttl) {
        lock.lock();
        Node node = cache.get(key);
        if (node == null) {
            node = new Node();
            node.value = value;
            node.key = key;
            node.priority = priority; // prioridade do elemento a ser colocado
            node.SOAEXPIRE = System.currentTimeMillis() + soaexpire;
            cache.put(key, node);
            addToFront(node);
            if (cache.size() > capacity) {
                System.out.println("A capacidade excedeu \n");
                // É removido o nodo menos usado recentemento (LFU) com prioridade mais pequena
                Node evicted = removeTail();
                while (evicted != null && evicted.priority <= priority) {
                    evicted = removeTail();
                }
                if (evicted != null) {
                    cache.remove(evicted.key);
                    System.out.println("Foi removido o nodo" + evicted.key + "com prioridade" + evicted.priority + "\n");
                }
            }
        } else {
            node.value = value;
            node.SOAEXPIRE = System.currentTimeMillis() + soaexpire;
            node.priority = priority;  // Atualizar a prioridade
            moveToFront(node);
        }
        // Implementação do ttl: tempo em que sistema se encontra + tempo ttl
        node.expirationTime = System.currentTimeMillis() + ttl;
        lock.unlock();
    }

    private void moveToFront(Node node) {
        removeNode(node);
        addToFront(node);
    }

    private void addToFront(Node node) {
        node.prev = head;
        node.next = head.next;
        head.next.prev = node;
        head.next = node;
    }

    private void removeNode(Node node) {
        node.prev.next = node.next;
        node.next.prev = node.prev;
    }

    private Node removeTail() {
        Node node = tail.prev;
        removeNode(node);
        return node;
    }

    private static class Node {
        private String key;
        private Message value;
        private long expirationTime;
        private Node prev;
        private Node next;
        private int priority;
        private long SOAEXPIRE;

        public String toString() {
            return "Nodo: " + key + " " + value.toString();
        }
    }

    public String toString() {
        return this.cache.toString();
    }
}