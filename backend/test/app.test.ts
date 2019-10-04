 // eslint-disable-next-line
const request = require("supertest");
import app from "../src/app";

describe("GET /random-url", () => {
    it("should return 404", (done) => {
        request(app)
            .get("/random-url")
            .expect(404, done);
    });
});
