import * as logger from "firebase-functions/logger";
import { getFirestore, CollectionReference } from "firebase-admin/firestore";
import { v4 as uuidv4 } from 'uuid'

export class FirestoreDAO<T extends { [x: string]: any; }> {

    constructor(
        readonly collectionName: string, 
        protected readonly idKey: string = "id"
    ){}

    private resolveId(document: any, assign: boolean = false): string {
        const stringify = `${document}`
        if(!document && !assign) {
            throw new Error("Document is undefined");
        } else if (document === stringify) {
            //isString?
            return stringify
        } if(this.idKey in document) {
            return document[this.idKey]
        } else if (assign) {
            const uuid = uuidv4()
            return uuid
        } else {
            return document
        }
    }

    protected collection(): CollectionReference {
        return getFirestore()
            .collection(this.collectionName)
    }

    public all(): Promise<T[]> {
        return this.collection()
            .get()
            .then((snapshot) => {
                return snapshot.docs.map((doc) => {
                    const data = doc.data() || {}
                    return data as T
                })
            })

    }

    public docRef(document: string | T) {
        const docId = this.resolveId(document)
        return this.collection()
            .doc(docId)
    }

    async remove(document: string | T): Promise<string|null> {
        const docId = this.resolveId(document)

        if(!docId) {
            return null
        }

        logger.debug(`Deleting doc ${docId} in ${this.collectionName}`)
        await this.collection()
            .doc(docId)
            .delete().catch((reason) => {
                logger.error(`Error deleting ${this.collectionName} ${docId} from firestore: ${reason.message}`)
            })
        logger.debug(`Successfully deleted doc ${docId} in ${this.collectionName}`)

        return docId
    }

    async save(data: T, document?: string): Promise<T> {
        const docId = document ? document : this.resolveId(data, true)

        if(!docId) {
            return data
        }

        const payload: any = {
            ...data,
        }
        payload[this.idKey] = docId

        //Strip undefined
        for(var key in payload) {
            if(payload[key] === undefined) {
                delete payload[key];
            }
        }

        const writeStarted = new Date().getTime()
        logger.debug(`Updating doc ${docId} in ${this.collectionName}`)
        await this.collection()
            .doc(docId)
            .set(payload, {
                merge: true
            }).catch((reason) => {
                logger.error(`Error writing ${this.collectionName} ${docId} to firestore: ${reason.message}`)
            })
        logger.debug(`Successfully updated doc ${docId} in ${this.collectionName} in ${new Date().getTime() - writeStarted}ms`)

        return payload as T
    }

    async load(document: string | T): Promise<T | undefined> {
        const docId = this.resolveId(document)

        if (!docId) {
            return undefined
        }

        const readStarted = new Date().getTime()
        const result = await this.collection()
            .doc(docId)
            .get()
            .then((doc) => {
                if (!doc.exists) {
                    return null
                } else {
                    const data = doc.data() || {};
                    data[this.idKey] = docId
                    return data
                }
                
            })
            .catch((reason) => {
                logger.error(`Error loading ${this.collectionName} ${docId} from firestore: ${reason.message}`)
                return undefined
            })
        
        logger.debug(`Reading ${docId} from ${this.collectionName} took ${new Date().getTime() - readStarted}ms`)
        return result as T
    }
}