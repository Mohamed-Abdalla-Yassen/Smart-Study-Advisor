from abc import ABC, abstractmethod
#Standard interface for both AI and Non-AI advisors
class BaseAdvisorService(ABC):
    @abstractmethod
    def get_recommendations(self, request_data: dict) -> list:
        pass