/* eslint no-console:0 */

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import Rails from "rails-ujs"
import * as ActiveStorage from "activestorage"
import Turbolinks from "turbolinks"
import Cable from "../utils/cable"

const application = Application.start()
const context = require.context("controllers", true, /.js$/)

Rails.start()
ActiveStorage.start()
Turbolinks.start()

application.load(definitionsFromContext(context))
