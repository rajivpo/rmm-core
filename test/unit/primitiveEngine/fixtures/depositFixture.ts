import { ethers } from 'hardhat'
import { PrimitiveEngineFixture, primitiveEngineFixture } from '../../fixtures'
import { Wallet, constants } from 'ethers'
import { loadFixture } from 'ethereum-waffle'
import { EngineDeposit } from '../../../../typechain'

export type PrimitiveEngineDepositFixture = PrimitiveEngineFixture & { deposit: EngineDeposit }

export async function primitiveEngineDepositFixture(signers: Wallet[]): Promise<PrimitiveEngineDepositFixture> {
  const [deployer] = signers
  const context = await loadFixture(primitiveEngineFixture)

  const deposit = ((await (await ethers.getContractFactory('EngineDeposit')).deploy(
    context.primitiveEngine.address,
    context.risky.address,
    context.stable.address
  )) as unknown) as EngineDeposit

  await context.stable.mint(deployer.address, constants.MaxUint256.div(4))
  await context.risky.mint(deployer.address, constants.MaxUint256.div(4))

  await context.stable.approve(deposit.address, constants.MaxUint256)
  await context.risky.approve(deposit.address, constants.MaxUint256)

  return {
    deposit,
    ...context,
  }
}