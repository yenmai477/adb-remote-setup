const { zerotierService } = require("./services");

require("./configs");

const main = async () => {
  const res = await zerotierService.getNetworkMembers();
  const { data: members } = res;
  const chromecast = zerotierService.getNetworkMemberContainingName(
    members,
    "chromecast"
  );

  if (!chromecast) {
    throw new Error("Not found chromecast in network!");
  }

  const chromecastIP = chromecast.config.ipAssignments[0];
  console.log(chromecastIP);
  process.env.chromecastIP = chromecastIP;
};

main();
