export type ProjectileTable = {
	StartCFrame: CFrame,
	EndCFrame: CFrame,
	Damage: number?,
	EmitDebris: number?,
	Velocity: number?,
	Drop: number?,
	Despawn: number?,
	XOffset: number?,
	YOffset: number?,
	ZOffset: number?,
	Decal: number?,
	Bullet: BasePart?,
	Sound: Sound?,
	Color: Color3?,
	Particles: ParticleEmitter?,
}

export type IgnoreList = { Instance? }

export type Projectile = {
	_projectile: BasePart,
	_projectileParent: Instance,
	_character: Model,
	_color: Color3,
	_damage: number,
	_decal: number,
	_despawn: number,
	_drop: number,
	_emitDebris: number,
	_ignoreList: IgnoreList,
	_laps: number,
	_oldPosition: CFrame,
	_origin: CFrame,
	_position: CFrame,
	_velocity: number,
	createBulletHole: (Projectile, number) -> (Part),
	weldProjectileHole: (Projectile, Ray, Color3?) -> (),
	getProjectileArray: () -> { Projectile },
}

export type DefaultValues = {
	DEFAULT_VELOCITY: number,
	DEFAULT_DROP: number,
	DEFAULT_DESPAWN: number,
	DEFAULT_DAMAGE: number,
	DEFAULT_EMIT_DEBRIS: number,
	DEFAULT_COLOR: Color3,
	DEFAULT_PROJECTILE_PARENT: Instance,
	DEFAULT_DECAL_ID: number,
	DEFAULT_PROJECTILE: Instance,
	DEFAULT_PARTICLES: ParticleEmitter,
	DEFAULT_TILT: number,
}

return nil
