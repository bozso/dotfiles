package download

type Config struct {
	EveOst EveOst `mapstructure:"eve_ost"`
}

func (cfg Config) Step() error {
	return cfg.EveOst.Download()
}
