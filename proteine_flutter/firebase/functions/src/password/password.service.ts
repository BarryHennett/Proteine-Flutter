import { FirebaseService, ServiceResponse } from "../tools/firebase.service";
import { getFirestore } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

//Send grid password Password@1234567

export interface CreatePasswordPayload {
  email: string;
  recoveryCode: string;
  password: String;
  confirmPassword: string;
}

export class PasswordService extends FirebaseService {
  private readonly firestore = getFirestore();
  private transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "boral490@gmail.com",
      pass: "lewl wlld dekj unhz",
    },
  });

  async checkEmail(email: string): Promise<ServiceResponse<any>> {
    try{
    console.log("Checking email:", email);
    const usersCollection = this.firestore.collection("users");
    const query = await usersCollection.where("email", "==", email).get();

    console.log(`Found ${query.size} documents with email: ${email}`, email);

    if (query.empty) {
      console.log(`No user found with email ${email}`);
      return this.missingError();
    }

    const recoveryCode = String(Math.floor(100000 + Math.random() * 900000));

    const emailData = { email, recoveryCode };

    await this.firestore.collection("recovery").doc(email).set({
      email: email,
      recoveryCode: recoveryCode,
    });
    console.log(`Recovery code ${recoveryCode} generated for email: ${email}`);
    await this.sendEmail(email, recoveryCode);

    return {
      success: true,
      data: emailData,
    };

    }catch (error) {
        console.error("Error checking email or storing recovery code:", error);
        return {
          success: false,
        }
    }
  }
  async sendEmail(email: string, recoveryCode: string): Promise<void> {
    const mailOptions = {
      from: "boral490@gmail.com",
      to: email,
      subject: "Your password recovery code",
      text: `Your recovery code is: ${recoveryCode}`,
    };
    await this.transporter.sendMail(mailOptions);
    console.log(`Recovery code ${recoveryCode} sent to email ${email} `);
  }

  async sendTestEmail(): Promise<ServiceResponse<any>> {
    const mailOptions = {
      from: "boral490@gmail.com",
      to: "vemogan527@abaot.com",
      subject: "Test Email",
      text: "This is a test email",
    };

    try {
      const info = await this.transporter.sendMail(mailOptions);
      console.log("Email sent: ", info.response);
      return {
        success: true,
      };
    } catch (error) {
      console.error("Error sending email: ", error);
      return {
        success: false,
      };
    }
  }
  async resetPassword(
    //payload: CreatePasswordPayload
    email: string,
    recoveryCode: string,
    password: string,
    confirmPassword: string
  ): Promise<ServiceResponse<any>> {
    // console.log(`Payload: ${payload}`);
    if (!recoveryCode || !email || !password || !confirmPassword) {
      console.log("Missing required fields in payload");
      return this.missingError();
    }
    // const code = payload.recoveryCode;
    // const email = payload.email;
    const recoveryCollection = this.firestore.collection("recovery");
    const userCollection = this.firestore.collection("users");
    console.log(`${recoveryCode}`);
    console.log(`${email}`);
    try {
      const recoveryQuery = await recoveryCollection
        .where("recoveryCode", "==", recoveryCode)
        .get();
      if (recoveryQuery.empty) {
        console.log("Recovery code not found");
        return this.missingError();
      }
      const userQuery = await userCollection.where("email", "==", email).get();
      if (userQuery.empty) {
        console.log("Email not found");
        return this.missingError();
      }
      const userDoc = userQuery.docs[0];
      const userId = userDoc.id;

      const newPassword = confirmPassword;

      if (!newPassword) {
        return this.missingError();
      }

      const userRecord = await admin.auth().getUserByEmail(email);
      if (!userRecord) {
        return this.missingError();
      }
      await admin.auth().updateUser(userRecord.uid, {
        password: newPassword,
      });

      console.log(`Password updated for user: ${userRecord.uid}`);

      // await userCollection.doc(userId).update({
      //   password: newPassword,
      // });
      await recoveryCollection.doc(email).delete();

      const updatedUser = userCollection.doc(userId).get();

      return {
        success: true,
        data: { user: updatedUser },
      };
    } catch (error) {
      console.error("Error resetting password", error);
      return { success: false };
    }
  }
}

