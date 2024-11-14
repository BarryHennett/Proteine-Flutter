import { FirebaseController } from "../tools/firebase.controller";
import { CreateUserPayload, UserService } from "./users.service";
import { Request, Response } from "express";

export class UserController extends FirebaseController {
  private readonly service = new UserService();

  constructor() {
    super((router, endpoints) => {
      endpoints.post(
        "/registerUser",
        async (request: Request, response: Response) => {
          try {
            const userPayload = (request.body || {}) as CreateUserPayload;
            const result = await this.service.registerUser(userPayload);
            this.sendResponse(response, result);
          } catch (error) {
            console.error(`Error registering User ${error}`);

            response.status(500).json({
              success: false,
              message: `Failed to register user: ${error}`,
            });
          }
        }
      );

      endpoints.delete("/:userId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }

        const result = await this.service.deleteUser(user.uid);

        this.sendResponse(response, result);
      });
      endpoints.put("/userId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const updatedUser = (request.body || {}) as CreateUserPayload;
        const result = await this.service.updateUser(user.uid, updatedUser);

        this.sendResponse(response, result);
      });
    });
  }
}
