
import { FirebaseService, ServiceResponse } from "../tools/firebase.service";
import {getFirestore} from "firebase-admin/firestore";

export interface CreateAttendancePayload {
    eventID: string
    userID: string
    status: string
    description: string

}

export class AttendanceService extends FirebaseService {

    private readonly firestore = getFirestore();

    async setAttendance(userId: string,  eventId: string, payload: CreateAttendancePayload): Promise<ServiceResponse<any>> {
        if (!payload.status) {
            return this.requestError("Missing required fields");
        }
        if(!eventId) {
            return this.missingError();
        }

        const eventDoc = await this.firestore.collection('events').doc(eventId).get();
        if(!eventDoc.exists) {
            return this.missingError();
        }

        const eventData = eventDoc.data();
        const attendees = eventData?.attendees || [];
    
        // const isAttendee = attendees.some((attendee: { userID: string }) => attendee.userID === userId);
        // if (!isAttendee) {
        //     return this.requestError("User is not an attendee of the event");
        // }

        payload.userID = userId;

        const newAttendance = {payload};
        const newAttendees ={attendees}
        const attendRef = await this.firestore.collection('attendance').add(newAttendance);
        const attendanceSet = {id: attendRef.id, ...newAttendance};
        const attendeesRef = await this.firestore.collection('events').add(newAttendees);
        const attendeesSet = {...attendeesRef}

        return {
            success: true,
            data: {attendanceSet, attendeesSet}
        }



    }
    async getAttendance(userId: string,  eventId: string, attendanceId: string): Promise<ServiceResponse<any>> {
        if(!eventId) {
            return this.missingError();
        }
        const event = await this.firestore.collection('events').doc(eventId).get();
        if(!event.exists) {
            return this.missingError();
        }
        const attendance = await this.firestore.collection('attendance').doc(attendanceId).get();
        if(!event.exists) {
            return this.missingError();
        }
        return { 
            success: true,
            data: {
                id: attendance.id,
                ...attendance.data()
            }
        }
    }
   
    async getAllAttendees(eventId: string): Promise<ServiceResponse<any>> {
        if(!eventId) {
            return this.missingError();
        }
        const eventDoc = await this.firestore.collection('events').doc(eventId).get();
        if (!eventDoc.exists) {
            return this.missingError();
        }
    
       
        const eventData = eventDoc.data();
        const attendees = eventData?.attendees || [];
    
        return {
            success: true,
            data: attendees  
        };
    }
    async updateAttendance(userId: string,  eventId: string, attendanceId: string, updatedAttendancePayload: CreateAttendancePayload): Promise<ServiceResponse<any>> {
        if(!eventId) {
            return this.missingError();
        }

        const attendRef = this.firestore.collection('attendance').doc(attendanceId);
        const attendanceCheck = await attendRef.get();

        if (!attendanceCheck.exists) {
            return this.missingError();
        }
        const updatedAttendance = {
            ...updatedAttendancePayload
        };
        await attendRef.update(updatedAttendance);

        return {
            success: true,
            data: updatedAttendance
        }
    }

}