import { FirebaseController } from "../tools/firebase.controller";
import { CreatePayload, TeamService } from "./teams.service";

export class TeamController extends FirebaseController {
  private readonly service = new TeamService();

  constructor() {
    super((router, endpoints) => {
      endpoints.post("/createTeam", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const createPayload = (request.body || {}) as CreatePayload;
        const result = await this.service.createTeam(user.uid, createPayload);
        this.sendResponse(response, result);
      });

      endpoints.get("/getTeams", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const result = await this.service.getAllTeams(user.uid);
        this.sendResponse(response, result);
      });
      endpoints.get("/getAllTeamsByClubId/:clubId", async(request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          console.log(`The User is: ${user}`);
          return await router.authResponse(response);
        }
        // //const clubId = request.body.clubId;
        // const body = (request.body || {});
        // const clubId = body.clubId;
        const clubId = request.params.clubId;
        const result = await this.service.getAllTeamsByClubId(clubId);

        // const testClubId = "2WdJvKdjT9xnQFxUpCYQ";
        // const result = await this.service.getAllTeamsByClubId(testClubId);

        this.sendResponse(response, result);
      });

      endpoints.get("/:teamId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const teamId = request.params.teamId;
        const result = await this.service.getTeam(user.uid, teamId);

        this.sendResponse(response, result);
      });

      endpoints.delete("/:teamId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const teamId = request.params.teamId;
        const result = await this.service.deleteTeam(user.uid, teamId);

        this.sendResponse(response, result);
      });

      endpoints.put("/:teamId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const teamId = request.params.teamId;
        const updatedPayload = (request.body || {}) as CreatePayload;
        const result = await this.service.updateTeam(
          user.uid,
          teamId,
          updatedPayload
        );

        this.sendResponse(response, result);
      });
    });
  }
}
