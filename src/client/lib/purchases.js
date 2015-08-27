import RestWrapper from './common/rest_wrapper';

class PurchaseStore extends RestWrapper {
  constructor(){
    super('/api/buys');
  }
  responseHandler(response) {
    return response.buys;
  }
}

export default new PurchaseStore();
