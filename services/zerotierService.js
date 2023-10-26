const { apiCall } = require("../utils");

exports.getNetworkMembers = (networkID) => {
  const calculatedNetworkID = networkID || process.env.ZEROTIER_NETWORK_ID;
  return apiCall.get(`network/${calculatedNetworkID}/member`);
};

exports.getNetworkMemberContainingName = (members, name) => {
  return members?.find((member) => member?.name?.toLowerCase().includes(name));
};
