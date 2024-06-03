import Docker from "dockerode"
import express, { Request, Response} from "express"
import cors from "cors"

const app = express()
const docker = new Docker({ socketPath: '/var/run/docker.sock' })

app.use(express.json())
app.use(cors())

app.get("/", (req: Request, res: Response) => {
    return res.status(200).json({ message: "Server running" })
})

app.post("/create-containers", async (req: Request, res: Response) => {
    const { poolAddress, mongoDbUri } = req.body

    if(!poolAddress || !mongoDbUri) {
        return res.status(400).json({ error: "Missing required fields" })
    }

    try {
        const container = await docker.createContainer({
            Image: `hidrogen/pool-${poolAddress}:latest`,
            Env: [
                `POOL_ADDRESS=${poolAddress}`,
                `MONGO_DB_URI=${mongoDbUri}`
            ]
        })
        await container.start()
    } catch (error) {
        
    }
})

app.post("/shutdown-container", async (req: Request, res: Response) => {
    const { poolAddress } = req.body

    if(!poolAddress) {
        return res.status(400).json({ error: "Missing required field: poolAddress" })
    }

    try {
        const containers = await docker.listContainers({ all: true })
        for (const containerInfo of containers) {
            const container = docker.getContainer(containerInfo.Id)
            const containerData = await container.inspect()

            const env = containerData.Config.Env || []
            const poolEnv = env.find(e => e.startsWith('POOL_ADDRESS='))
            const poolEnvAddress = poolEnv?.split('=')[1]

            if (poolEnvAddress === poolAddress) {
                await container.stop()
                return res.status(200).json({ message: `Container with pool address ${poolAddress} has been stopped` })
            }
        }

        return res.status(404).json({ error: `No running container found with pool address ${poolAddress}` })
    } catch (error) {
        return res.status(500).json({ error: 'An error occurred while trying to stop the container' })
    }
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});