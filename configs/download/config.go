package download

type Config struct {
	EveOst   EveOst   `mapstructure:"eve_ost"`
	Arkenfox Arkenfox `mapstructure:"arkenfox"`
}

func (cfg Config) Step() error {
	err := cfg.EveOst.Download()
	if err != nil {
		return err
	}

	err = cfg.Arkenfox.Setup()
	return err
}
