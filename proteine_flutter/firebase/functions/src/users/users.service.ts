import { FirebaseService, ServiceResponse } from "../tools/firebase.service";
import { getFirestore } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";

export interface CreateUserPayload {
  fullName: string;
  email: string;
  password?: string;
  clubRole: string;
  dob: string;
  address: string;
  phNumber: string;
  emergencyContact: string;
}

export class UserService extends FirebaseService {
  private readonly firestore = getFirestore();
  private auth = getAuth();

  async registerUser(
    userPayload: CreateUserPayload
  ): Promise<ServiceResponse<any>> {
    if (
      !userPayload.fullName ||
      !userPayload.email ||
      !userPayload.password ||
      !userPayload.clubRole ||
      !userPayload.dob ||
      !userPayload.address ||
      !userPayload.phNumber ||
      !userPayload.emergencyContact
    ) {
      return this.requestError("Missing required fields");
    }
    //Error registering User Error: The phone number must be a non-empty E.164 standard compliant identifier string.

    const usersCollection = this.firestore.collection("users");

    const userRecord = await this.auth.createUser({
      email: userPayload.email,
      password: userPayload.password,
      phoneNumber: userPayload.phNumber,
    });
    const newUser = { ...userPayload };
    delete newUser.password;
    await usersCollection.doc(userRecord.uid).set(newUser);
    const userRef = usersCollection.doc(userRecord.uid).get();

    const createdUser = { id: (await userRef).id, ...(await userRef).data() };

    return {
      success: true,
      data: createdUser,
    };
  }
  async deleteUser(userId: string): Promise<ServiceResponse<any>> {
    if (!userId) {
      return this.missingError();
    }
    const userRef = this.firestore.collection("users").doc(userId);
    const user = await userRef.get();

    if (!user.exists) {
      return this.missingError();
    }
    await this.auth.deleteUser(userId);
    await userRef.delete();

    return {
      success: true,
    };
  }
  async updateUser(
    userId: string,
    updatedUserPayload: CreateUserPayload
  ): Promise<ServiceResponse<any>> {
    if (!userId) {
      return this.missingError();
    }
    const userRef = this.firestore.collection("users").doc(userId);
    const user = await userRef.get();

    if (!user.exists) {
      return this.missingError();
    }
    const updatedUser = {
      ...updatedUserPayload,
    };

    await userRef.update(updatedUser);

    return {
      success: true,
      data: updatedUser,
    };
  }
}
