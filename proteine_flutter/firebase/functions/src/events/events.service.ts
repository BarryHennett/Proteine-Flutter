//import { deleteEvent } from "../events";
import { FirebaseService, ServiceResponse } from "../tools/firebase.service";
import {getFirestore} from "firebase-admin/firestore";


export interface CreatePayload {
    organiser: string
    eventName: string 
    description: string 
    date: string
    startTime: string 
    endTime: string 
    recurring: string 
    eventType: string
    reminder: string
    status: string
    playerSelection: String
    attendees?: Attendee[]; 
}
export interface Attendee {
    uid: string
    fullName: string
}



export class EventsService extends FirebaseService {

    private readonly firestore = getFirestore();


    async getEvent(userId: string, eventId: string): Promise<ServiceResponse<any>> {
        if(!eventId) {
            return this.missingError();
        }

        const event = await this.firestore.collection('events').doc(eventId).get();
        if(!event.exists) {
            return this.missingError();
        }

        return {
            success: true,
            data: {
                id: event.id,
                organiser: userId,
                ...event.data(),
                attendees: event.data()?.attendees || []
            }
        }
    }

    async createEvent(userId: string, payload: CreatePayload): Promise<ServiceResponse<any>> {
        if (!payload.eventName || !payload.description || !payload.date || !payload.startTime || !payload.endTime || !payload.eventType || !payload.status) {
            return this.requestError("Missing required fields");
        }

        const newEvent = {...payload,
            //attendees: payload.attendees || [],
            attendees: [...(payload.attendees || [], userId)]
        };
        const eventRef = await this.firestore.collection('events').add(newEvent);
        const createdEvent = {id: eventRef.id, ...newEvent};

        return {
            success: true,
            data: createdEvent
        }
    }

    async getEventsForUser(userId: string): Promise<ServiceResponse<any>> {
        // const events = await this.firestore.collection('events').where('userId', '==', userId).get();
        const events = await this.firestore.collection('events').get();
        const eventData = events.docs.map(event => {
            return {id: event.id,
                 ...event.data().payload,
                 attendees: event.data().attendees || []
                }
        })

        return {
            success: true,
            data: {
                events: eventData,

            }
        }
    }
    async deleteEvent( userId: string, eventId: string): Promise<ServiceResponse<any>>{
        if(!eventId){
            return this.missingError();
        }

        const eventRef = this.firestore.collection('events').doc(eventId);
        const event = await eventRef.get();

        if(!event.exists){
            return this.missingError();
        }

        await eventRef.delete();

        return{
            success: true
        };
    }
    async updateEvent(userId: string, eventId: string, updatedPayload: CreatePayload): Promise<ServiceResponse<any>> {
        if(!eventId) {
            return this.missingError();
        }

        const eventRef = this.firestore.collection('events').doc(eventId);
        const event = await eventRef.get();

        if (!event.exists) {
            return this.missingError();
        }
        const updatedEvent = { 
            ...updatedPayload,
            attendees: updatedPayload.attendees || []
        };

        await eventRef.update(updatedEvent);

        return {
            success: true,
            data: updatedEvent
        };
    }
    
}