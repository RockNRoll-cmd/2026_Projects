//cpp program to generate a short cache simulator
#include <iostream>
#include <vector>
#include <cmath>
#include <unordered_map>
#include <list>
using namespace std;
//cache block structure
struct CacheBlock {
    int tag;
    bool valid;
    CacheBlock() : tag(0), valid(false) {}
};
//cache set structure
struct CacheSet {
    vector<CacheBlock> blocks;
    list<int> lru; // for LRU replacement policy
    CacheSet(int associativity) : blocks(associativity) {}
};
//cache structure
class Cache {
private:
    int blockSize;
    int cacheSize;
    int associativity;
    int numSets;
    vector<CacheSet> sets;
public:
    Cache(int blockSize, int cacheSize, int associativity) 
        : blockSize(blockSize), cacheSize(cacheSize), associativity(associativity) {
        numSets = (cacheSize / blockSize) / associativity;
        sets.resize(numSets, CacheSet(associativity));
    }
    // function to access the cache
    bool access(int address) {
        int blockOffsetBits = log2(blockSize);
        int indexBits = log2(numSets);
        int tagBits = 32 - indexBits - blockOffsetBits;

        int blockOffset = address & ((1 << blockOffsetBits) - 1);
        int index = (address >> blockOffsetBits) & ((1 << indexBits) - 1);
        int tag = address >> (blockOffsetBits + indexBits);

        CacheSet& set = sets[index];
        for (int i = 0; i < associativity; i++) {
            if (set.blocks[i].valid && set.blocks[i].tag == tag) {
                // Cache hit
                set.lru.remove(i);
                set.lru.push_back(i); // Update LRU
                return true;
            }
        }
        // Cache miss
        if (set.lru.size() < associativity) {
            // There is space in the set
            int newIndex = set.lru.size();
            set.blocks[newIndex].tag = tag;
            set.blocks[newIndex].valid = true;
            set.lru.push_back(newIndex);
        } else {
            // Evict the least recently used block
            int evictIndex = set.lru.front();
            set.lru.pop_front();
            set.blocks[evictIndex].tag = tag;
            set.blocks[evictIndex].valid = true;
            set.lru.push_back(evictIndex);
        }
        return false;
    }
};
int main() {
    int blockSize = 64; // 64 bytes
    int cacheSize = 1024; // 1 KB
    int associativity = 4; // 4-way set associative
    Cache cache(blockSize, cacheSize, associativity);

    vector<int> addresses = {0x0000, 0x0040, 0x0080, 0x00C0, 0x0000, 0x0040, 0x0100};
    for (int address : addresses) {
        if (cache.access(address)) {
            cout << "Cache hit for address: " << hex << address << endl;
        } else {
            cout << "Cache miss for address: " << hex << address << endl;
        }
    }
    return 0;
}

