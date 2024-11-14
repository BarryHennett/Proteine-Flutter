import { FirebaseController } from "../tools/firebase.controller";
import { ClubService } from "./clubs.service";
import { CreatePayload } from "./clubs.service";

export class ClubController extends FirebaseController {
  private readonly service = new ClubService();

  constructor() {
    super((router, endpoints) => {
      endpoints.post("/createClub", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const createPayload = (request.body || {}) as CreatePayload;
        const result = await this.service.createClub(user.uid, createPayload);
        this.sendResponse(response, result);
      });

      endpoints.get("/getClubs", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const result = await this.service.getAllClubs(user.uid);
        this.sendResponse(response, result);
      });

      endpoints.get("/:clubId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const clubId = request.params.clubId;
        const result = await this.service.getClub(user.uid, clubId);

        this.sendResponse(response, result);
      });

      endpoints.delete("/:clubId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const clubId = request.params.clubId;
        const result = await this.service.deleteClub(user.uid, clubId);

        this.sendResponse(response, result);
      });

      endpoints.put("/:clubId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const clubId = request.params.clubId;
        const updatedPayload = (request.body || {}) as CreatePayload;
        const result = await this.service.updateClub(
          user.uid,
          clubId,
          updatedPayload
        );

        this.sendResponse(response, result);
      });
    });
  }
}
