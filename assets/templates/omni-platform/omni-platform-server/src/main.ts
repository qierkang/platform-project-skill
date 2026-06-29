import "dotenv/config";
import cors from "@fastify/cors";
import Fastify from "fastify";

const app = Fastify({ logger: true });
const port = Number(process.env.SERVER_PORT || 7060);

await app.register(cors, {
  origin: true,
});

app.get("/health", async () => ({
  status: "ok",
  service: "omni-platform-server",
  timestamp: new Date().toISOString(),
}));

app.get("/meta", async () => ({
  projectName: process.env.PROJECT_NAME || "Omni Platform",
  projectSlug: process.env.PROJECT_SLUG || "omni-platform",
  version: process.env.PROJECT_VERSION || "1.0.0-alpha",
  ports: {
    server: port,
    front: Number(process.env.FRONT_PORT || 7061),
    mobile: Number(process.env.MOBILE_PORT || 7062),
  },
}));

app
  .listen({ host: "0.0.0.0", port })
  .catch((error) => {
    app.log.error(error);
    process.exit(1);
  });
