/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { onRequest } from "firebase-functions/v2/https";
import * as express from "express";
import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions/v2/options";
import { initializeFirestore } from "firebase-admin/firestore";
import { EventController } from "./events/events.controller";
import { AttendanceController } from "./attendance/attendance.controller";
import { UserController } from "./users/users.controller";
import { TeamController } from "./teams/teams.controller";
import { PasswordController } from "./password/password.controller";
//import { PlaceController } from "./placesAPI/places.controller";
import * as cors from "cors";
import { ClubController } from "./clubs/clubs.controller";

const app = admin.initializeApp();
setGlobalOptions({
  maxInstances: 2,
});
initializeFirestore(app, {
  // preferRest: true
});

const endpoints = express();
endpoints.disable("x-powered-by");
endpoints.use(cors({ origin: true }));
endpoints.use(async (_: any, response: any, next: any) => {
  response.header("Content-Type", "application/json");
  next();
});

const eventEndpoints = new EventController().endpoints;

const attendanceEndpoints = new AttendanceController().endpoints;

const userEndpoints = new UserController().endpoints;

const teamEndpoints = new TeamController().endpoints;

const clubEndpoints = new ClubController().endpoints;

const passwordEndpoints = new PasswordController().endpoints;

//const placeEndpoints = new PlaceController().endpoints

endpoints.use("/events", eventEndpoints);
endpoints.use("/attendance", attendanceEndpoints);
endpoints.use("/users", userEndpoints);
endpoints.use("/teams", teamEndpoints);
endpoints.use("/passwords", passwordEndpoints);
endpoints.use("/clubs", clubEndpoints);
//endpoints.use("/places", placeEndpoints)

export const api = onRequest(
  {
    memory: "1GiB",
  },
  endpoints
);
