//
//  TODOLIST.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/19.
//

//import Foundation

// todo list

// DailyAuctionVC


// DetailInfoVC
// backButton 터치 시 dailyAuctionVC present
// Model 가져와 데이터 띄우기
// 버튼 3개 둥글게, 토글
// graph 라이브러리가져와 구현
// DailyVC protocol 연결해?


// InfoBoardVC
// 각 버튼에 이미지 넣기
// 시장경매시간 view 터치 시 Detail시장경매VC 넘어가기


// BookmarkVC
// cell xib 생성
// 하단 추가 버튼 터치 시 모든 품목 cell data에 추가
// 각 cell 터치 시 색 on off 토글
// 저장 버튼 터치 시 현재 on상태인 cell 모아 coreData에 추가
// 취소 버튼 터치 시 하단 추가버튼으로 다시 back


// MainTabVC
// 키보드 올라온 뒤 배경 누르면 키보드 내리기
// SearchImageButton 터치이벤트 구현
// TabMan + topView 높이 구해서 다른 VC에서 그만큼 topAnchor 수정하기

// bookmark 탭 들어가면
// 처음에 내가 북마크 한 cell만 보여야함 -> productBookmarkedData == coredata.read
// 이후 추가 버튼을 누르면 전체 cell 보여야함 -> productAllData
// 거기서 cell 선택한 것들을 이미지 노랗게 바꾸고
// 저장 버튼 누르면 coredata.add
