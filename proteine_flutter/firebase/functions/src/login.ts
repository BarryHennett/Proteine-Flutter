

import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import * as logger from 'firebase-functions/logger'



//Login function(POST)

export const login = onRequest(async(request, response) =>{
    if(request.method !== 'POST'){
        response.status(405).send({error: 'Method not Allowed'});
        return;
    }
    const { email, password } = request.body;
    if(!email || !password){
        response.status(400).send({error: 'Missing email or password'});
    }
    try{
        const userEmail = await admin.auth().getUserByEmail(email);
        const customToken = await admin.auth().createCustomToken(userEmail.uid);

        const user = await admin.auth().verifyIdToken(customToken);
        if(user.email !== email){
            response.status(401).send({error: 'Invalid credentials'});
        }
        response.status(200).send({token: customToken});
    }catch(error){
        logger.error('Error logging in:', error);
        response.status(500).send({error: 'Internal Server Error'});

    }
})


//Create new User(POST)

export const createUser = onRequest(async(request, response) =>{
    if(request.method !== 'POST'){
        response.status(405).send({error: 'Method not Allowed'});
        return;
    }
    const{ email, password } = request.body;

    if(!email || !password){
        response.status(400).send({error: 'Missing email or password'});
        return;
    }

    try{
        const userLogin = await admin.auth().createUser({
            email: email,
            password: password,

        });
        response.status(201).send({message: 'User created successfully', uid: userLogin.uid});
    }catch(error){
        logger.error('Error creating user:', error);
        response.status(500).send({error: 'Internal Server Error'});
    }
});

