import * as logger from "firebase-functions/logger";
import * as core from "express-serve-static-core";
import * as express from "express";
import { getAuth } from "firebase-admin/auth";

export interface Pagination {
    offset: number
    count: number
    total?: number
}

export interface ResponsePayload<T> {
    success: boolean
    code?: number
    message?: string
    data?: T
}

export interface AuthenticatedUser {
    uid: string,
    email?: string
}

export class FirebaseController {

    readonly endpoints: core.Router

    constructor(build: (router: FirebaseController, endpoints: core.Router) => void) {
        this.endpoints = express.Router();
        build(this, this.endpoints)
    }

    async getUser(request: express.Request): Promise<AuthenticatedUser|null> {
        if(request) {
            const jwt = request.headers['authorization']
            if(jwt) {
                const lookup: AuthenticatedUser | null = await getAuth().verifyIdToken(jwt).then((token) => {
                    return {
                        uid: token.uid,
                        email: token.email,
                    }
                }, (reason) => {
                    logger.info(`Could not verify JWT token ${reason.message}`)
                    return null;
                })

                if(lookup && lookup.uid) {
                    return lookup
                }
            }
        }
        return null
    }

    async sendResponse<T extends any>(response: express.Response, data: ResponsePayload<T> | undefined | null) {
        if (!data || data == null) {
            data = {
                success: false
            }
        }
        const code = data.code || (data.success ? 200 : 500);
        const message = data.message || (data.success ? "Success" : "Internal Server Error");
        response.status(code).send(JSON.stringify({
            'success': data.success,
            'message': message,
            'data': data.data || {}
        }));
    }

    async sendJson<T extends any>(response: express.Response, data: any | undefined | null) {
        const success = data != null && data != undefined
        const code = success ? 200 : 500;
        response.status(code).send(JSON.stringify(data || {}));
    }
    
    async successResponse(response: express.Response, data: any, message?: string, code?: number) {
        await this.sendResponse(response, {
            success: true,
            message: message,
            code: code,
            data: data
        })
    }
    
    async errorResponse(response: express.Response, message: string, code?: number, data?: any) {
        await this.sendResponse(response, {
            success: false,
            message: message,
            code: code || 400,
            data: data
        })
    }
    
    async authResponse(response: express.Response) {
        await this.sendResponse(response, {
            success: false,
            message: "Not Authorized",
            code: 401,
        })
    }
}