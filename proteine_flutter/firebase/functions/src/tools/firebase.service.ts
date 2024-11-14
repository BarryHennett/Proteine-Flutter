import * as logger from "firebase-functions/logger";
import { ResponsePayload } from "./firebase.controller";

export interface ServiceResponse<T extends {[x: string]: any;}> extends ResponsePayload<T> {

}

export class FirebaseService {

    authError(message?: string): ServiceResponse<any> {
        const resolvedMessage = message || "Not Authorized"
        logger.debug(`Responding with AUTH error, reason: ${resolvedMessage}`)
        return {
            success: false,
            code: 401,
            message: resolvedMessage
        }
    }

    requestError(message?: string): ServiceResponse<any> {
        const resolvedMessage = message || "Bad Request"
        logger.debug(`Responding with REQ error, reason: ${resolvedMessage}`)
        return {
            success: false,
            code: 403,
            message: resolvedMessage
        }
    }

    missingError(message?: string): ServiceResponse<any> {
        const resolvedMessage = message || "Not Found"
        logger.debug(`Responding with Missing error, reason: ${resolvedMessage}`)
        return {
            success: false,
            code: 404,
            message: resolvedMessage
        }
    }
}