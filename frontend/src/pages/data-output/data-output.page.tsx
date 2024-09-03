import { useGetDataOutputByIdQuery } from '@/store/features/data-outputs/data-outputs-api-slice.ts';
import { useNavigate, useParams } from 'react-router-dom';
import { Flex, Space, Typography } from 'antd';
import styles from './data-output.module.scss';
// import { DataOutputTabs } from '@/pages/data-output/components/data-output-tabs/data-output-tabs.tsx';
import { DataOutputActions } from '@/pages/data-output/components/data-output-actions/data-output-actions.component.tsx';
import { LoadingSpinner } from '@/components/loading/loading-spinner/loading-spinner.tsx';
import { DataOutputDescription } from '@/pages/data-output/components/data-output-description/data-output-description.tsx';
import { useEffect, useMemo } from 'react';
import { getDataOutputIcon } from '@/utils/data-output-type-icon.helper.ts';
import Icon, { SettingOutlined } from '@ant-design/icons';
import clsx from 'clsx';
import { ApplicationPaths, DynamicPathParams } from '@/types/navigation.ts';
import { CircleIconButton } from '@/components/buttons/circle-icon-button/circle-icon-button.tsx';
import { useTranslation } from 'react-i18next';
import { selectCurrentUser } from '@/store/features/auth/auth-slice.ts';
import { useSelector } from 'react-redux';
// import { getDataOutputOwners, getIsDataOutputOwner } from '@/utils/data-output-user-role.helper.ts';
import { getDynamicRoutePath } from '@/utils/routes.helper.ts';
import { UserAccessOverview } from '@/components/data-access/user-access-overview/user-access-overview.component.tsx';
import { LocalStorageKeys, setItemToLocalStorage } from '@/utils/local-storage.helper.ts';
import { DataOutputTabs } from './components/data-output-tabs/data-output-tabs';

export function DataOutput() {
    const { t } = useTranslation();
    const currentUser = useSelector(selectCurrentUser);
    const { dataOutputId = '' } = useParams();
    const { data: dataOutput, isLoading } = useGetDataOutputByIdQuery(dataOutputId, { skip: !dataOutputId });
    const navigate = useNavigate();

    const dataOutputTypeIcon = useMemo(() => {
        return getDataOutputIcon(dataOutput?.configuration_type);
    }, [dataOutput?.id, dataOutput?.configuration_type]);

    // const dataOutputOwners = dataOutput ? getDataOutputOwners(dataOutput) : [];
    // const isCurrentDataOutputOwner = Boolean(
    //     dataOutput && currentUser && (getIsDataOutputOwner(dataOutput, currentUser?.id) || currentUser?.is_admin),
    // );

    function navigateToEditPage() {
        if (//isCurrentDataOutputOwner &&
            dataOutputId) {
            navigate(
                getDynamicRoutePath(ApplicationPaths.DataOutputEdit, DynamicPathParams.DataOutputId, dataOutputId),
            );
        }
    }

    // useEffect(() => {
    //     setItemToLocalStorage(LocalStorageKeys.LastVisitedDataOutputs, {
    //         id: dataOutputId,
    //         timestamp: Date.now(),
    //     });
    // }, []);

    if (isLoading) return <LoadingSpinner />;

    if (!dataOutput) {
        navigate(ApplicationPaths.DataOutputs, { replace: true });
        return null;
    }

    return (
        <Flex className={styles.dataOutputContainer}>
            <Flex vertical className={styles.content}>
                <Flex className={styles.headerContainer}>
                    <Space className={styles.header}>
                        <Icon
                            component={dataOutputTypeIcon}
                            className={clsx([styles.defaultIcon, styles.iconBorder])}
                        />
                        <Typography.Title level={3} ellipsis={{ tooltip: dataOutput?.name, rows: 2 }}>
                            {dataOutput?.name}
                        </Typography.Title>
                    </Space>
                    {//isCurrentDataOutputOwner &&
                    (
                        <Space className={styles.editIcon}>
                            <CircleIconButton
                                icon={<SettingOutlined />}
                                tooltip={t('Edit data output')}
                                onClick={navigateToEditPage}
                            />
                        </Space>
                    )}
                </Flex>
                {/* Main content */}
                <Flex className={styles.mainContent}>
                    {/* Data product description */}
                    <Flex vertical className={styles.overview}>
                        <DataOutputDescription
                            status={dataOutput.status}
                            type={dataOutput.configuration_type}
                            description={dataOutput.description}
                        />
                        {/*  Tabs  */}
                        <DataOutputTabs dataOutputId={dataOutput.id} isLoading={isLoading} />
                    </Flex>
                </Flex>
            </Flex>
            {/* Sidebar */}
            {/* <Flex vertical className={styles.sidebar}> */}
                {/* <DataOutputActions dataOutputId={dataOutputId} /> */}
                {/*  Data product owners overview */}
                {/* <UserAccessOverview users={dataOutputOwners} title={t('Data Output Owners')} /> */}
            {/* </Flex> */}
        </Flex>
    );
}