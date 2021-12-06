const { ethers } = require("hardhat")

const deploy = async () => {
  // getSigners() trae la información que traemos desde nuestra llave privada
  // deployer es un objeto que nos permite desplegar contratos a la red que tengamos configurada
  const [deployer] = await ethers.getSigners()
  console.log("Deploying contract with the account: ", deployer.address)

  // Definimos ProjectPunks en el contexto
  const ProjectPunks = await ethers.getContractFactory("ProjectPunks")
  // Instancia del contracto desplegado
  const deployed = await ProjectPunks.deploy()
  console.log("Project Punks is deployed at: ", deployed.address)
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error)
    proccess.exit(1)
  })