import mongoose from "mongoose";


export type EmailDocument = mongoose.Document & {
    email: string;
};


const emailSchema = new mongoose.Schema({
    email: { type: String, unique: true }
}, { timestamps: true });


export const Email = mongoose.model<EmailDocument>("Email", emailSchema);
