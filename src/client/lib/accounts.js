import RestWrapper from './common/rest_wrapper';

class AccountStore extends RestWrapper {
  constructor() {
    super('/api/users');
  }
  responseHandler(response) {
    response.users.forEach((user)=> {
      user.balance = parseFloat(user.balance);
    });
    return response.users;
  }
}

export default new AccountStore();
