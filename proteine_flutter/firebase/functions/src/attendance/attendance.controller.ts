import { FirebaseController } from "../tools/firebase.controller";
import { CreateAttendancePayload, AttendanceService } from "./attendance.service";

export class AttendanceController extends FirebaseController {
    private readonly service = new AttendanceService();
    

    constructor() {
        super((router, endpoints) =>{

            endpoints.post("/setAttendance", async (request, response) => {
                const user = await router.getUser(request);
                if(!user) {
                    return await router.authResponse(response);
                }
                
                const eventId = request.body.eventID;

                const createAttendancePayload = (request.body || {}) as CreateAttendancePayload;
                const result = await this.service.setAttendance(user.uid, eventId, createAttendancePayload )
                this.sendResponse(response, result);
            
            });
            endpoints.get("/getAttendance", async (request, response) => {
                const user = await router.getUser(request);
                if(!user) {
                    return await router.authResponse(response);
                }
                const userId = user.uid;
                const eventId = request.body.eventId;
                const attendanceId = request.body.attendanceId;
                const result = await this.service.getAttendance(userId, eventId, attendanceId);

                this.sendResponse(response, result);
            });
            endpoints.get("/getAttendees", async (request, response) =>{
                const user = await router.getUser(request);
                if(!user) {
                    return await router.authResponse(response);
                }
                const eventId = request.body.eventId;
                const result = await this.service.getAllAttendees(eventId);

                this.sendResponse(response, result);


            })
            endpoints.put("/updateAttendance", async (request, response) => {
                const user = await router.getUser(request);
                if(!user) {
                    return await router.authResponse(response);
                }
                
                const eventId = request.body.eventId;
                const attendanceId = request.body.attendanceId;
                const updatedAttendancePayload = (request.body || {}) as CreateAttendancePayload;
                const result = await this.service.updateAttendance(user.uid, eventId, attendanceId, updatedAttendancePayload);

                this.sendResponse(response, result);

            });
            
        })
    }
}