const
  API_HOST = 'localhost',
  API_PORT = 3000,
  BASE_PATH = '/api',
  SECURE = false;

function apiUrl(path) {
  return `http${SECURE ? 's' : ''}://${API_HOST}:${API_PORT}/${BASE_PATH}/${path}`;
}

export { SECURE, API_HOST, API_PORT, BASE_PATH };
export { apiUrl };


