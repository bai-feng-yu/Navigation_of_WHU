#include "historymodel.h"
#include <QMultiMap>
#include <QRandomGenerator>

// 构造函数
HistoryModel::HistoryModel()
{
    /**
     * 初始化历史记录数据。
     * 使用循环生成20条包含随机数字和"测试"前缀的字符串，并将它们添加到m_historyData列表中。
     */
    // for (int i = 0; i < 20; ++i) {
    //     QString randStr;
    //     // 生成一个长度为10的随机数字符串
    //     for (int j = 0; j < 10; ++j) {
    //         randStr += QString::number(QRandomGenerator::global()->generate() % 10);
    //     }
    //     // 将生成的随机数字符串前加上"测试"前缀，然后添加到m_historyData中
    //     m_historyData.push_back("测试" + randStr);
    // }
    m_historyData.push_back("武汉大学图书馆");
    m_historyData.push_back("武汉大学牌坊");

    // 初始化m_data为m_historyData的副本，用于展示
    m_data = m_historyData;
}
/* 要求必须被重写的函数 */
// 返回模型中的行数
int HistoryModel::rowCount(const QModelIndex &parent) const
{
    // 如果parent不是无效索引（在简单的列表中，parent总是无效的），则忽略它
    Q_UNUSED(parent);
    // 返回m_data中的条目数
    return m_data.count();
}

// 返回模型中的列数（对于简单的列表模型，通常是1）
int HistoryModel::columnCount(const QModelIndex &parent) const
{
    // 同样，忽略parent
    Q_UNUSED(parent);
    return 1;
}

// 返回指定索引和角色的数据
QVariant HistoryModel::data(const QModelIndex &index, int role) const
{
    // 检查索引是否有效
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    // 根据角色返回数据
    switch (role) {
    case Qt::DisplayRole:
        // 对于显示角色，返回对应行的数据
        return m_data.at(index.row());

    default:
        // 对于其他角色，不返回任何数据
        break;
    }

    // 默认返回无效的QVariant
    return QVariant();
}

// 根据关键字对历史记录进行排序
void HistoryModel::sortByKey(const QString &key)
{
    // 如果关键字为空，则重置m_data为m_historyData的副本
    if (key.isEmpty()) {
        beginResetModel();
        m_data = m_historyData;
        endResetModel();
    } else {
        // 使用QMultiMap根据关键字首次出现的位置进行排序
        QMultiMap<int, QString> temp;
        // 遍历m_historyData，查找包含关键字的字符串
        for (const auto &str : qAsConst(m_historyData)) {
            int ret = str.indexOf(key);
            // 如果字符串不包含关键字，则跳过
            if (ret == -1) continue;
            // 否则，将字符串插入到temp中，键为关键字出现的位置
            temp.insert(ret, str);
        }

        // 开始更新模型 /*将c++文件数据变化 提示给 视图 */
        beginResetModel();
        // 清空当前的数据
        m_data.clear();
        // 如果temp不为空，则将其内容复制到m_data中
        if (!temp.isEmpty()) {
            // 遍历temp，将值（即字符串）添加到m_data中
            for (auto it = temp.begin(); it != temp.end(); it++) {
                m_data.push_back(it.value());
            }
        }
        // 结束更新模型
        endResetModel();
    }
}
