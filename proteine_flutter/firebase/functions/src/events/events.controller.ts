import { FirebaseController } from "../tools/firebase.controller";
import { CreatePayload, EventsService } from "./events.service";

export class EventController extends FirebaseController {
  private readonly service = new EventsService();

  constructor() {
    super((router, endpoints) => {
      endpoints.post("/create", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }

        const createPayload = (request.body || {}) as CreatePayload;
        const result = await this.service.createEvent(user.uid, createPayload);
        this.sendResponse(response, result);
      });

      endpoints.get("/search", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }

        const result = await this.service.getEventsForUser(user.uid);

        this.sendResponse(response, result);
      });

      endpoints.get("/:eventId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }

        const eventId = request.params.eventId;
        const result = await this.service.getEvent(user.uid, eventId);

        this.sendResponse(response, result);
      });
      endpoints.delete("/:eventId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const eventId = request.params.eventId;
        const result = await this.service.deleteEvent(user.uid, eventId);

        this.sendResponse(response, result);
      });
      endpoints.put("/:eventId", async (request, response) => {
        const user = await router.getUser(request);
        if (!user) {
          return await router.authResponse(response);
        }
        const eventId = request.params.eventId;
        const updatePayload = (request.body || {}) as CreatePayload;
        const result = await this.service.updateEvent(
          user.uid,
          eventId,
          updatePayload
        );

        this.sendResponse(response, result);
      });
    });
  }
}
