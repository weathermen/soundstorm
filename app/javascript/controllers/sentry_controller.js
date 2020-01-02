import { Controller } from "stimulus"
import * as Sentry from "@sentry/browser"

/**
 * Track JavaScript errors with Sentry in production.
 */
export default class extends Controller {
  connect() {
    const env = this.data.get("env")

    if (env === "production") {
      const dsn = this.data.get("dsn")

      Sentry.init({ dsn })
    }
  }
}
