import { Controller } from "stimulus"
import * as Sentry from "@sentry/browser"

export default class extends Controller {
  connect() {
    const env = this.data.get("env")
    const dsn = this.data.get("dsn")

    if (env === "production") {
      Sentry.init({ dsn })
    }
  }
}
