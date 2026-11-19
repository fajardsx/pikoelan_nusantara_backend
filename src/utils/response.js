// Helper function untuk standardize response
const sendResponse = (res, code, success, message, data = null) => {
  const response = {
    code,
    success,
    message,
  };

  if (data !== null) {
    response.data = data;
  }

  return res.status(code).json(response);
};

module.exports = { sendResponse };