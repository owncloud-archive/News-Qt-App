#ifndef ownCloudNews_HPP_
#define ownCloudNews_HPP_

#include <QObject>

namespace bb { namespace cascades { class Application; }}

class ownCloudNews : public QObject
{
    Q_OBJECT
public:
    ownCloudNews(bb::cascades::Application *app);
    virtual ~ownCloudNews() {}
};

#endif /* ownCloudNews_HPP_ */

