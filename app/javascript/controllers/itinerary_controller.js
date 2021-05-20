import { Controller } from "stimulus";
import initMapbox;

export default class extends Controller {
  static targets = [ 'select' ];

  connect() {
    console.log('hello');
  }
}