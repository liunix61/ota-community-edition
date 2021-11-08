ALTER TABLE `DevicePublicCredentials`
ADD COLUMN `type_credentials` ENUM('PEM', 'OAuthClientCredentials') NOT NULL DEFAULT 'PEM',
ADD COLUMN created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
;

ALTER TABLE `DevicePublicCredentials` ALTER COLUMN `type_credentials` DROP DEFAULT
;