import { FirebaseController } from "../tools/firebase.controller";
import {  PasswordService } from "./password.service";


export class PasswordController extends FirebaseController {
    private readonly service = new PasswordService();

    constructor(){
        super((router, endpoints) =>{
            endpoints.post("/checkEmail", async(request, response)=>{
                try{
                    const body = (request.body|| {});
                    const email = body.email;
                    const result = await this.service.checkEmail(email);

                    this.sendResponse(response, result);
                }catch(error){
                    console.error("Error checking email", error);
                   
                }
            });
            endpoints.put("/resetPassword", async(request, response) =>{
                const updatePassword = (request.body || {});
                console.log(`This is the request package: ${request.body}`);
                const email = updatePassword.email;
                const recoveryCode = updatePassword.recoveryCode;
                const password = updatePassword.password;
                const confirmPassword = updatePassword.confirmPassword;
                console.log(`email: ${email}`);
                console.log(`recoveryCode: ${recoveryCode}`);
                console.log(`Password: ${password}`);
                //const result = await this.service.resetPassword(updatePassword);
                const result = await this.service.resetPassword(email, recoveryCode, password, confirmPassword);

                this.sendResponse(response, result);

            });
            endpoints.get("/testEmail", async(request, response) =>{
                const result = await this.service.sendTestEmail();
                this.sendResponse(response, result);
            })
        });
    }
}