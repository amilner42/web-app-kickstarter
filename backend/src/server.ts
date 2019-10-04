import errorHandler from "errorhandler";

import app from "./app";
import { IS_PROD } from "./util/secrets";


if (!IS_PROD) {
    app.use(errorHandler());
}


const server = app.listen(app.get("port"), () => {
    console.log(
        "  App is running at http://localhost:%d in %s mode",
        app.get("port"),
        app.get("env")
    );
    console.log("  Press CTRL-C to stop\n");
});


export default server;
