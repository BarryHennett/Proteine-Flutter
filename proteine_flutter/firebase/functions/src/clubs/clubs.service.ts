import { FirebaseService, ServiceResponse } from "../tools/firebase.service";
import { getFirestore } from "firebase-admin/firestore";

export interface CreatePayload {
  clubName: string;
  city: string;
  country: string;
  stadium: string;
  teams?: Team[];
}
export interface Team {
  uid: string;
  teamName: string;
}


export class ClubService extends FirebaseService {
  private readonly firestore = getFirestore();

  async createClub(
    userId: string,
    payload: CreatePayload
  ): Promise<ServiceResponse<any>> {
    if (!payload.clubName) {
      return this.requestError("Missing required fields");
    }
    const newClub = {
      payload,
      teams: payload.teams || [],
    };
    const clubRef = await this.firestore.collection("clubs").add(newClub);
    const createdClub = { id: clubRef.id, ...newClub };

    return {
      success: true,
      data: createdClub,
    };
  }
  async getAllClubs(userId: String): Promise<ServiceResponse<any>> {
    const clubs = await this.firestore.collection("clubs").get();
    const clubData = clubs.docs.map((club) => {
      return {
        id: club.id,
        ...club.data().payload,
        teams: club.data().teams
      };
    });
    return {
      success: true,
      data: {
        clubs: clubData,
      },
    };
  }
  async getClub(userId: string, clubId: string): Promise<ServiceResponse<any>> {
    if (!clubId) {
      return this.missingError();
    }
    const club = await this.firestore.collection("clubs").doc(clubId).get();
    if (!club.exists) {
      return this.missingError();
    }
    return {
      success: true,
      data: {
        id: club.id,
        ...club.data(),
        teams: club.data()?.teams || [],
      },
    };
  }
  async deleteClub(
    userId: string,
    clubId: string
  ): Promise<ServiceResponse<any>> {
    if (!clubId) {
      return this.missingError();
    }
    const clubRef = this.firestore.collection("clubs").doc(clubId);
    const club = await clubRef.get();

    if (!club.exists) {
      return this.missingError();
    }
    await clubRef.delete();

    return {
      success: true,
    };
  }
  async updateClub(
    userId: string,
    clubId: string,
    updatedPayload: CreatePayload
  ): Promise<ServiceResponse<any>> {
    if (!clubId) {
      return this.missingError();
    }
    const clubRef = this.firestore.collection("clubs").doc(clubId);
    const club = await clubRef.get();
    if (!club.exists) {
      return this.missingError();
    }
    const updatedClub = {
      ...updatedPayload,
      teams: updatedPayload.teams || [],
    };
    await clubRef.update(updatedClub);

    return {
      success: true,
      data: updatedClub,
    };
  }
}
