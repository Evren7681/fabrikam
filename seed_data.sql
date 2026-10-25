-- ====================================================================
-- FABRİKA CMMS - TEST VE SAHA DEMO SEED VERİSİ
-- Kapsam: 10 Adet Makine, 20 Adet Yedek Parça, Kullanıcılar ve Son 1 Aylık Arıza/Duruş Kayıtları
-- ====================================================================

BEGIN;

-- 1. KULLANICILAR (Bakım Yöneticisi, Teknisyenler, Operatör)
INSERT INTO users (id, badge_number, full_name, role, department, is_active) VALUES
    ('11111111-1111-1111-1111-111111111111', 'P-1001', 'Evren Zak', 'supervisor', 'Bakım Yönetimi', true),
    ('22222222-2222-2222-2222-222222222222', 'P-1002', 'Ahmet Yılmaz', 'technician', 'Mekanik Bakım', true),
    ('33333333-3333-3333-3333-333333333333', 'P-1003', 'Mehmet Demir', 'technician', 'Elektrik & Otomasyon', true),
    ('44444444-4444-4444-4444-444444444444', 'P-1004', 'Ali Kaya', 'operator', 'Üretim Pres Hattı', true)
ON CONFLICT (badge_number) DO NOTHING;

-- 2. 10 ADET MAKİNE / EKİPMAN (A, B, C Kritiklik Seviyeleri ve Bölümler)
INSERT INTO assets (id, code, name, level, criticality, location, technical_specs, is_active) VALUES
    ('a0000001-0000-0000-0000-000000000001', 'PRS-01', '1 No''lu Hidrolik Pres (630 Ton)', 'machine', 'A', 'Pres Hattı', '{"motor_kw": 45, "max_pressure_bar": 210, "oil_capacity_l": 600}'::jsonb, true),
    ('a0000002-0000-0000-0000-000000000002', 'PRS-02', '2 No''lu Mekanik Eksantrik Pres (250 Ton)', 'machine', 'B', 'Pres Hattı', '{"motor_kw": 30, "stroke_per_min": 45}'::jsonb, true),
    ('a0000003-0000-0000-0000-000000000003', 'PRS-03', '3 No''lu Çift Tesirli Pres (400 Ton)', 'machine', 'A', 'Pres Hattı', '{"motor_kw": 37, "max_pressure_bar": 190}'::jsonb, true),
    ('a0000004-0000-0000-0000-000000000004', 'FRN-01', 'Tünel Fırın Ana Yanma ve Brülör Grubu', 'machine', 'A', 'Fırın Bölümü', '{"max_temp_c": 1250, "burners_count": 16, "gas_pressure_mbar": 300}'::jsonb, true),
    ('a0000005-0000-0000-0000-000000000005', 'FRN-02', 'Ön Isıtma ve Kurutma Fırını', 'machine', 'B', 'Fırın Bölümü', '{"max_temp_c": 250, "circulation_fans": 4}'::jsonb, true),
    ('a0000006-0000-0000-0000-000000000006', 'MIX-01', 'Hammadde Yoğun Karıştırıcı (Mikser 500L)', 'machine', 'A', 'Hazırlık Hattı', '{"motor_kw": 55, "drum_speed_rpm": 42}'::jsonb, true),
    ('a0000007-0000-0000-0000-000000000007', 'MIX-02', 'Kuru Karışım Bunker ve Elevatörü', 'machine', 'B', 'Hazırlık Hattı', '{"motor_kw": 15, "capacity_tph": 10}'::jsonb, true),
    ('a0000008-0000-0000-0000-000000000008', 'CNV-01', 'Soğutma ve Çıkış Rulolu Konveyör', 'machine', 'C', 'Paketleme', '{"motor_kw": 5.5, "length_meters": 35}'::jsonb, true),
    ('a0000009-0000-0000-0000-000000000009', 'PAK-01', 'Otomatik Robotik Paletleme ve Çemberleme', 'machine', 'B', 'Paketleme', '{"payload_kg": 250, "robot_axis": 4}'::jsonb, true),
    ('a0000010-0000-0000-0000-00000000010', 'KOM-01', 'Vidalı Kompresör Ünitesi (7.5 Bar)', 'machine', 'A', 'Kompresör Dairesi', '{"motor_kw": 75, "flow_m3_min": 12.8}'::jsonb, true)
ON CONFLICT (code) DO NOTHING;

-- 3. 20 ADET YEDEK PARÇA VE SARF MALZEME (Kritik Stok Seviyeleriyle)
INSERT INTO spare_parts (id, part_number, name, shelf_location, current_stock, min_safety_stock, unit, unit_cost) VALUES
    ('b0000001-0000-0000-0000-000000000001', 'PMP-SL-01', 'Hidrolik Pompa Şaft Keçesi (80x100x10 Viton)', 'A-01-02', 8, 3, 'adet', 320.00),
    ('b0000002-0000-0000-0000-000000000002', 'VLF-NG6-24V', 'Yön Kontrol Valfi Rexroth NG6 24VDC', 'B-03-01', 3, 2, 'adet', 4250.00),
    ('b0000003-0000-0000-0000-000000000003', 'FLT-HYD-10U', 'Yüksek Basınç Yağ Filtresi 10 Mikron', 'A-04-05', 12, 4, 'adet', 850.00),
    ('b0000004-0000-0000-0000-000000000004', 'RL-6205-2RS', 'Rulman SKF 6205-2RSH/C3', 'C-02-01', 24, 10, 'adet', 145.00),
    ('b0000005-0000-0000-0000-000000000005', 'RL-6309-2RS', 'Rulman SKF 6309-2RS1 Ağır Hizmet', 'C-02-04', 10, 4, 'adet', 380.00),
    ('b0000006-0000-0000-0000-000000000006', 'MOT-11KW-B3', 'Asenkron Motor Gamak 11kW 1400d/d B3', 'D-01-01', 1, 1, 'adet', 18500.00),
    ('b0000007-0000-0000-0000-000000000007', 'BRN-ELK-01', 'Fırın Ateşleme Elektrodu ve Bujisi', 'E-01-02', 15, 6, 'adet', 275.00),
    ('b0000008-0000-0000-0000-000000000008', 'BRN-UV-SEN', 'Kromschröder UV Alev Dedektörü Sensörü', 'E-01-05', 2, 2, 'adet', 3600.00),
    ('b0000009-0000-0000-0000-000000000009', 'TRM-K-TYP', 'Termokupl K-Tipi 1200°C 500mm Seramik Kılıf', 'E-02-01', 6, 2, 'adet', 1100.00),
    ('b0000010-0000-0000-0000-000000000010', 'SLN-PNE-50', 'Pnömatik Silindir Festo DNC-50-250-PPV-A', 'B-01-03', 4, 2, 'adet', 2400.00),
    ('b0000011-0000-0000-0000-000000000011', 'CNT-3TF44', 'Kontaktör Siemens 3TF44 32A 24VDC', 'F-01-02', 7, 3, 'adet', 920.00),
    ('b0000012-0000-0000-0000-000000000012', 'RLY-FIND-24', 'Röle Finder 24VDC 2 Açık 2 Kapalı + Soket', 'F-02-01', 35, 10, 'adet', 85.00),
    ('b0000013-0000-0000-0000-000000000013', 'PSU-SITOP-20', 'Güç Kaynağı Siemens SITOP PSU100M 24V 20A', 'F-03-01', 2, 1, 'adet', 5800.00),
    ('b0000014-0000-0000-0000-000000000014', 'SNS-PRX-M18', 'Endüktif Sensör Telemecanique M18 PNP NO 8mm', 'G-01-01', 14, 5, 'adet', 420.00),
    ('b0000015-0000-0000-0000-000000000015', 'OIL-ISO-46', 'Hidrolik Yağ Shell Tellus S2 MX 46 (Varil)', 'DEP-YAG-01', 4, 2, 'varil', 14200.00),
    ('b0000016-0000-0000-0000-000000000016', 'GRS-EP-2', 'Yüksek Sıcaklık Rulman Gresi Mobil Polyrex EM', 'DEP-YAG-02', 18, 5, 'kg', 240.00),
    ('b0000017-0000-0000-0000-000000000017', 'KAY-V-SPB2000', 'V-Kayış Optibelt SPB 2000', 'C-04-02', 12, 4, 'adet', 190.00),
    ('b0000018-0000-0000-0000-000000000018', 'HOS-HYD-2SN', '2SN 3/8" Hidrolik Hortum 330 Bar (Metre)', 'A-05-01', 45, 15, 'metre', 160.00),
    ('b0000019-0000-0000-0000-000000000019', 'ZNC-16B-1', 'Tahrik Zinciri 1" 16B-1 Makaralı (Rulo 5m)', 'C-05-01', 3, 1, 'rulo', 2150.00),
    ('b0000020-0000-0000-0000-000000000020', 'ESTOP-PILZ', 'E-Stop Acil Durdurma Butonu Buton Gövdesi', 'G-02-01', 6, 2, 'adet', 310.00)
ON CONFLICT (part_number) DO NOTHING;

-- 4. GEÇMİŞ 1 AYLIK DURUŞ VE İŞ EMRİ KAYITLARI (Pareto ve MTTR/MTBF Beslemesi)

-- Arıza 1: 1 No'lu Pres Ana Pompa Basınç Kaybı (PRS-01) -> 125 dk Duruş
INSERT INTO downtime_events (id, asset_id, start_time, production_resumed_time)
VALUES ('c0000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', NOW() - INTERVAL '24 days 4 hours', NOW() - INTERVAL '24 days 1 hour 55 mins');

INSERT INTO work_orders (
    id, client_uuid, asset_id, type, status, failure_category,
    reported_at, started_at, completed_at, reported_by, assigned_to,
    description, actions_taken, five_whys, root_cause_summary, downtime_id
) VALUES (
    'd0000001-0000-0000-0000-000000000001', 'e0000001-0000-0000-0000-000000000001',
    'a0000001-0000-0000-0000-000000000001', 'corrective', 'completed', 'hydraulic',
    NOW() - INTERVAL '24 days 4 hours', NOW() - INTERVAL '24 days 3 hours 45 mins', NOW() - INTERVAL '24 days 2 hours',
    '44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222',
    'Pres baskı basamağında basınç 120 bar altına düşüyor, koç aşağı inmiyor.',
    'Oransal yön valfi tıkalı bulundu, sökülüp temizlendi. Yüksek basınç filtre kartuşu yenilendi.',
    '["Pres baskı yapamadı","Basınç 120 bar üzerine çıkamadı","Oransal yön valfi orifisinde metal talaş birikmiş","Hat filtresi tıkandığı için baypas hattı açılmış","Filtre değişim periyodu aşılmış"]'::jsonb,
    'Periyodik hidrolik filtre değişim saatinin geciktirilmesi sonucu valf kirliliği',
    'c0000001-0000-0000-0000-000000000001'
);

INSERT INTO work_order_parts (work_order_id, part_id, quantity) VALUES
    ('d0000001-0000-0000-0000-000000000001', 'b0000003-0000-0000-0000-000000000003', 1);

-- Arıza 2: Tünel Fırın Brülör Sönmesi (FRN-01) -> 80 dk Duruş
INSERT INTO downtime_events (id, asset_id, start_time, production_resumed_time)
VALUES ('c0000002-0000-0000-0000-000000000002', 'a0000004-0000-0000-0000-000000000004', NOW() - INTERVAL '18 days 6 hours', NOW() - INTERVAL '18 days 4 hours 40 mins');

INSERT INTO work_orders (
    id, client_uuid, asset_id, type, status, failure_category,
    reported_at, started_at, completed_at, reported_by, assigned_to,
    description, actions_taken, five_whys, root_cause_summary, downtime_id
) VALUES (
    'd0000002-0000-0000-0000-000000000002', 'e0000002-0000-0000-0000-000000000002',
    'a0000004-0000-0000-0000-000000000004', 'corrective', 'completed', 'automation',
    NOW() - INTERVAL '18 days 6 hours', NOW() - INTERVAL '18 days 5 hours 50 mins', NOW() - INTERVAL '18 days 4 hours 45 mins',
    '44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333333',
    '3 No''lu zon brülörü ateşleme yapmıyor, gaz valfi kilitleniyor.',
    'Ateşleme elektrodu kurum bağlamış, temizlendi ve mesafe ayarlandı. UV alev sensörü yenisiyle değiştirildi.',
    '["Fırın sıcaklığı 3. zonda düştü","3 No brülör devreye girmedi","Alev kontrol rölesi sinyal alamadı","UV sensör camı aşırı ısı ve is nedeniyle kararmış","Sensör soğutma havası hattı vanası kısık kalmış"]'::jsonb,
    'Alev dedektörü soğutma havasının yetersiz olması kaynaklı sensör camı kararması',
    'c0000002-0000-0000-0000-000000000002'
);

INSERT INTO work_order_parts (work_order_id, part_id, quantity) VALUES
    ('d0000002-0000-0000-0000-000000000002', 'b0000008-0000-0000-0000-000000000008', 1),
    ('d0000002-0000-0000-0000-000000000002', 'b0000007-0000-0000-0000-000000000007', 2);

-- Arıza 3: Mikser Redüktör Aşırı Isınma & Rulman Bozulması (MIX-01) -> 85 dk Duruş
INSERT INTO downtime_events (id, asset_id, start_time, production_resumed_time)
VALUES ('c0000003-0000-0000-0000-000000000003', 'a0000006-0000-0000-0000-000000000006', NOW() - INTERVAL '12 days 8 hours', NOW() - INTERVAL '12 days 6 hours 35 mins');

INSERT INTO work_orders (
    id, client_uuid, asset_id, type, status, failure_category,
    reported_at, started_at, completed_at, reported_by, assigned_to,
    description, actions_taken, five_whys, root_cause_summary, downtime_id
) VALUES (
    'd0000003-0000-0000-0000-000000000003', 'e0000003-0000-0000-0000-000000000003',
    'a0000006-0000-0000-0000-000000000006', 'corrective', 'completed', 'mechanical',
    NOW() - INTERVAL '12 days 8 hours', NOW() - INTERVAL '12 days 7 hours 45 mins', NOW() - INTERVAL '12 days 6 hours 40 mins',
    '44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222',
    'Mikser tamburundan şiddetli sürtünme sesi geliyor ve motor termik açıyor.',
    'Ön yatak rulmanı söküldü, bilyaların dağıldığı görüldü. Yeni 6309-2RS rulman çakıldı ve greslendi.',
    '["Mikser motoru termik attı","Yatak aşırı ısındı ve kilitlendi","Rulman bilyaları dağılmış","Yatak içine mikser toz kaçağı olmuş","Toz keçesi aşınmış ve yağlama kanalı tıkanmış"]'::jsonb,
    'Toz keçesinin yıpranması ve toz girişinin rulmanı sarması',
    'c0000003-0000-0000-0000-000000000003'
);

INSERT INTO work_order_parts (work_order_id, part_id, quantity) VALUES
    ('d0000003-0000-0000-0000-000000000003', 'b0000005-0000-0000-0000-000000000005', 2),
    ('d0000003-0000-0000-0000-000000000003', 'b0000016-0000-0000-0000-000000000016', 1);

-- Arıza 4: Vidalı Kompresör Termostatik Valf Açmama (KOM-01) -> 45 dk Duruş
INSERT INTO downtime_events (id, asset_id, start_time, production_resumed_time)
VALUES ('c0000004-0000-0000-0000-000000000004', 'a0000010-0000-0000-0000-000000000010', NOW() - INTERVAL '7 days 2 hours', NOW() - INTERVAL '7 days 1 hour 15 mins');

INSERT INTO work_orders (
    id, client_uuid, asset_id, type, status, failure_category,
    reported_at, started_at, completed_at, reported_by, assigned_to,
    description, actions_taken, five_whys, root_cause_summary, downtime_id
) VALUES (
    'd0000004-0000-0000-0000-000000000004', 'e0000004-0000-0000-0000-000000000004',
    'a0000010-0000-0000-0000-000000000010', 'corrective', 'completed', 'mechanical',
    NOW() - INTERVAL '7 days 2 hours', NOW() - INTERVAL '7 days 1 hour 50 mins', NOW() - INTERVAL '7 days 1 hour 15 mins',
    '44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222',
    'Kompresör 105°C yüksek sıcaklık alarmıyla durdu, hat havası düştü.',
    'Radyatör petekleri basınçlı hava ile temizlendi, termostatik valf kiti sökülüp temizlendi ve yağ eklendi.',
    '["Hava basıncı 5 bara düştü","Kompresör yüksek sıcaklık hatası verdi","Yağ soğutucu radyatörü ısı transferi yapamadı","Radyatör ızgaraları ortam tozuyla tamamen dolmuş","Haftalık otonom radyatör temizliği atlanmış"]'::jsonb,
    'Çevresel toz birikintisi nedeniyle yağ radyatörünün hava geçişinin tıkanması',
    'c0000004-0000-0000-0000-000000000004'
);

-- Arıza 5: Konveyör Tahrik Motor Kontaktör Yanığı (CNV-01) -> 35 dk Duruş
INSERT INTO downtime_events (id, asset_id, start_time, production_resumed_time)
VALUES ('c0000005-0000-0000-0000-000000000005', 'a0000008-0000-0000-0000-000000000008', NOW() - INTERVAL '3 days 5 hours', NOW() - INTERVAL '3 days 4 hours 25 mins');

INSERT INTO work_orders (
    id, client_uuid, asset_id, type, status, failure_category,
    reported_at, started_at, completed_at, reported_by, assigned_to,
    description, actions_taken, five_whys, root_cause_summary, downtime_id
) VALUES (
    'd0000005-0000-0000-0000-000000000005', 'e0000005-0000-0000-0000-000000000005',
    'a0000008-0000-0000-0000-000000000008', 'corrective', 'completed', 'electrical',
    NOW() - INTERVAL '3 days 5 hours', NOW() - INTERVAL '3 days 4 hours 50 mins', NOW() - INTERVAL '3 days 4 hours 25 mins',
    '44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333333',
    'Soğutma konveyörü start almıyor, panodan koku geldi.',
    'Pano kontrol edildi, K1 ana hat kontaktör kontaklarının ark yaparak yapıştığı görüldü. Kontaktör yenilendi.',
    '["Konveyör çalışmadı","Motor sürücü/kontaktör çıkış vermedi","Kontaktör L2-T2 kontağı eriyip yapışmış","Sık dur-kalk çalışma sebebiyle aşırı ark oluşmuş","Mekanik sıkışma motor akımını nominalin üzerine çıkarmış"]'::jsonb,
    'Makaralardaki sıkışma kaynaklı yüksek demeraj akımı ve kontaktör kontak erimesi',
    'c0000005-0000-0000-0000-000000000005'
);

INSERT INTO work_order_parts (work_order_id, part_id, quantity) VALUES
    ('d0000005-0000-0000-0000-000000000005', 'b0000011-0000-0000-0000-000000000011', 1);

COMMIT;
