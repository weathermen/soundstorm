import * as ActionCable from 'actioncable'
import '../channels/*'

export default {
  start() {
    return ActionCable.createConsumer()
  }
}
