typedef void(^CDUnknownBlockType)(void);
struct sCSTypeRef {
    void* csCppData;    // typically retrieved using CSCppSymbol...::data(csData & 0xFFFFFFF8)
    void* csCppObj;        // a pointer to the actual CSCppObject
};
typedef struct sCSTypeRef CSTypeRef;
typedef CSTypeRef CSSymbolRef;
typedef struct CSTypeRef _CSTypeRef;
