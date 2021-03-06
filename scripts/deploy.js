const deploy = async () => {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contract with the account:", deployer.address);

  const MyPunks = await ethers.getContractFactory("MyPunks");
  const deployed = await MyPunks.deploy(10000);

  console.log("MyPunks is deployed at:", deployed.address);
};

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
