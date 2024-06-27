--drop schema exp cascade;

-- схема для экспериментальных данных
create schema exp;

-- номер эксперимента
create sequence exp.exp_number_seq;

-- история эксперимента 
create table exp.exp_history (  
  exp_id 		int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts		timestamp default current_timestamp,		-- тс начала/конца
  event_type 	varchar(8) 									-- начало/конец
);

-- список агентов в эксперименте
create table exp.agent_in_exp (
  exp_id 	int default currval('exp.exp_number_seq'), 	-- номер эксперимента
  event_ts	timestamp default current_timestamp,		-- тс регистрации агента 
  agent 	varchar(32) 								-- агент 
);

-- история сделок между агентами
create table exp.deal_history (
  exp_id 	int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts 	timestamp default current_timestamp,		-- тс сделки 
  time 		double precision, 							-- время сделки
  buyer 	varchar(32), 								-- покупатель
  seller 	varchar(32), 								-- продавец
  b2b 		double precision, 							-- желаемый покупателем продукт (b2b=s2s)
  b2s 		double precision, 							-- продаваемый покупателем продукт
  s2b 		double precision, 							-- желаемый продавцом продукт 
  s2s 		double precision							-- продаваемый продавцом продукт (b2b=s2s)
);

-- история состояний агента 
create table exp.state_history (
  exp_id 			int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts 			timestamp default current_timestamp,		-- тс перехода в состояние
  time 				double precision,							-- время перехода в состояние 
  agent 			varchar(32),								-- агент 
  state 			varchar(20), 								-- состояние 
  is_buyer 			bool, 										-- является покупателем? 
  has_target 		bool, 										-- есть цель?
  has_money 		bool,										-- есть деньги?
  product_to_buy 	double precision,							-- желаемый продукт 
  product_to_sell	double precision							-- продаваемый продукт 
);

-- история сообщений между агентами
create table exp.message_history (
  exp_id 	int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts 	timestamp default current_timestamp,		-- тс получения сообщения
  time 		double precision, 							-- время получения сообщения
  sender 	varchar(32), 								-- агент-отправитель
  receiver	varchar(32), 								-- агент-получатель
  msg 		varchar(32) 								-- текст сообщения
);

-- история перемещений агента
create table exp.move_history (
  exp_id 	int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts 	timestamp default current_timestamp,		-- тс перемещения
  time 		double precision, 							-- время перемещения
  agent 	varchar(32), 								-- агент
  oldX 		double precision, 							-- исходные координаты
  oldY 		double precision, 							-- исходные координаты
  direction	varchar(10), 								-- направление (для дистретного пространства)
  newX 		double precision, 							-- новые координаты (для непрерывного пространства)
  newY 		double precision, 							-- новые координаты (для непрерывного пространства)
  targetX 	double precision, 							-- целевые координаты
  targetY 	double precision 							-- целевые координаты
);

-- история целей агента
create table exp.target_history (
  exp_id 	int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts	timestamp default current_timestamp,		-- тс изменения 
  time 		double precision, 							-- время изменения 
  agent 	varchar(32), 								-- агент 
  action 	varchar(32), 								-- операция над массивом (add/insert/clear)
  index 	varchar(32), 								-- позиция в массиве
  value 	varchar(32) 								-- значение, добавленное в массивом
);


-- история полезности
create table exp.utility_history (
  exp_id 		int default currval('exp.exp_number_seq'),	-- номер эксперимента
  event_ts 		timestamp default current_timestamp, 		-- тс изменения 
  time 			double precision, 							-- время изменения 
  agent 		varchar(32), 								-- агент 
  added_utility	double precision, 							-- добавленная полезность
  saved_utility double precision 							-- накопленная полезность
);



-- справочник кодов
create table exp.reference (
  type 			varchar(32),	-- тип/набор
  code 			int,			-- код
  description	varchar(128)	-- описание
);