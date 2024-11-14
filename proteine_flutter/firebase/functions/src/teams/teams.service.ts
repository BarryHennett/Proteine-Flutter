import { FirebaseService, ServiceResponse } from "../tools/firebase.service";
import { getFirestore } from "firebase-admin/firestore";

export interface CreatePayload {
  teamName: string;
  clubId: string,
  players?: Player[];
  coaches?: Coach[];
}
export interface Player {
  uid: string;
  fullName: string;
}
export interface Coach {
  uid: string;
  fullName: string;
}

export class TeamService extends FirebaseService {
  private readonly firestore = getFirestore();

  async createTeam(
    userId: string,
    payload: CreatePayload
  ): Promise<ServiceResponse<any>> {
    if (!payload.teamName) {
      return this.requestError("Missing required fields");
    }
    const clubCollection = await this.firestore.collection("clubs");
    //const clubCheck = await clubCollection.where("id", "==", payload.clubId).get();
    
    //const clubId = payload.clubId;
    const teamName = payload.teamName;

    // if(clubCheck.empty){
    //   return this.missingError();
    // }
    const newTeam = {
      teamName: payload.teamName,
      clubId: payload.clubId,
      players: payload.players || [],
      coaches: payload.coaches || [],
    };
    const teamRef = await this.firestore.collection("teams").add(newTeam);
    const teamId = teamRef.id;
    const createdTeam = { id: teamRef.id, ...newTeam };
    const clubDoc = await clubCollection.doc(payload.clubId);
    const teamAdded = await clubDoc.update({
      teams: {teamId, teamName,}
    })

    return {
      success: true,
      data: {createdTeam, teamAdded}
    };
  }
  async getAllTeams(userId: String): Promise<ServiceResponse<any>> {
    const teams = await this.firestore.collection("teams").get();
    const teamData = teams.docs.map((team) => {
      return {
        id: team.id,
        ...team.data().payload,
        players: team.data().players || [],
        coaches: team.data().coaches || [],
      };
    });
    return {
      success: true,
      data: {
        clubs: teamData,
      },
    };
  }
  async getAllTeamsByClubId(clubId: string): Promise<ServiceResponse<any>>{
    try{
    console.log(clubId);
    const teamCollection = await this.firestore.collection("teams").where("clubId", "==", clubId).get();
    //const teams: any[] = [];
    if(teamCollection.empty){
      return this.missingError();
    }

    // teamCollection.forEach((doc) =>{
    //   teams.push(doc.data());
    // });
    const teamData = teamCollection.docs.map(team => {
      return {
        id: team.id,
        ...team.data().payload,
         teamName: team.data().teamName,
         clubId: team.data().clubId,
        players: team.data().players || [],
        coaches: team.data().coaches || [],
      };
      
    });
    console.log(`This is the Team with this Club ID ${teamData}`);
    return{
      success: true,
      data: {teams: teamData,}
      
    };
  }
  catch(error){
    console.log(error);
    return{
      success: false, 
      message: `${error}`
    };
  }

  }
  async getTeam(userId: string, teamId: string): Promise<ServiceResponse<any>> {
    if (!teamId) {
      return this.missingError();
    }
    const team = await this.firestore.collection("teams").doc(teamId).get();
    if (!team.exists) {
      return this.missingError();
    }
    return {
      success: true,
      data: { teams: {
        id: team.id,
        ...team.data(),
        players: team.data()?.players || [],
        coaches: team.data()?.coaches || [],
      }
      },
    };
  }
  async deleteTeam(
    userId: string,
    teamId: string
  ): Promise<ServiceResponse<any>> {
    if (!teamId) {
      return this.missingError();
    }
    const teamRef = this.firestore.collection("teams").doc(teamId);
    const team = await teamRef.get();

    if (!team.exists) {
      return this.missingError();
    }
    await teamRef.delete();

    return {
      success: true,
    };
  }
  async updateTeam(
    userId: string,
    teamId: string,
    updatedPayload: CreatePayload
  ): Promise<ServiceResponse<any>> {
    if (!teamId) {
      return this.missingError();
    }
    const teamRef = this.firestore.collection("teams").doc(teamId);
    const team = await teamRef.get();
    if (!team.exists) {
      return this.missingError();
    }
    const updatedTeam = {
      ...updatedPayload,
      players: updatedPayload.players || [],
      coaches: updatedPayload.coaches || [],
    };
    await teamRef.update(updatedTeam);

    return {
      success: true,
      data: updatedTeam,
    };
  }
}
