import { Container } from "@cloudflare/containers";
import { WorkerEntrypoint } from "cloudflare:workers";

interface Env {
  CZAR_CONTAINER: DurableObjectNamespace;
  APP_HOST?: string;
  DATABASE_URL?: string;
  SECRET_KEY_BASE?: string;
  RAILS_MAX_THREADS?: string;
}

export class CzarContainer extends Container {
  defaultPort = 3000;
  sleepAfter = "10m";
  enableInternet = true;

  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env);

    this.envVars = {
      RAILS_ENV: "production",
      RAILS_LOG_LEVEL: "info",
      SOLID_QUEUE_IN_PUMA: "1",
      APP_HOST: env.APP_HOST ?? "",
      DATABASE_URL: env.DATABASE_URL ?? "",
      SECRET_KEY_BASE: env.SECRET_KEY_BASE ?? "",
      RAILS_MAX_THREADS: env.RAILS_MAX_THREADS ?? "5",
    };
  }
}

export default class extends WorkerEntrypoint {
  async fetch(request: Request): Promise<Response> {
    const id = this.env.CZAR_CONTAINER.idFromName("czar");
    const container = this.env.CZAR_CONTAINER.get(id);
    return container.fetch(request);
  }
}
