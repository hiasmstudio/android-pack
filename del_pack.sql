BEGIN TRANSACTION;
DELETE FROM pack_compilers WHERE pack_id = (SELECT p.id FROM packs p WHERE p.codename = 'android');
DELETE FROM info_id_ru WHERE id = (SELECT p.info_id FROM packs p WHERE p.codename = 'android');
DELETE FROM info_id_ru WHERE id = (SELECT pr.info_id FROM projects pr WHERE pr.pack_id = (SELECT p.id FROM 
packs p WHERE p.codename = 'android'));
DELETE FROM projects WHERE pack_id = (SELECT p.id FROM packs p WHERE p.codename = 'android');
DELETE FROM packs WHERE codename = 'android';
COMMIT;
